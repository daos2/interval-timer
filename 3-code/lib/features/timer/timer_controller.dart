import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../backup/backup_service.dart';
import '../settings/app_settings.dart';
import '../settings/settings_repository.dart';
import '../statistics/workout_history_repository.dart';
import '../statistics/workout_record.dart';
import 'sound_service.dart';

enum TimerPhase { idle, prestart, workout, rest, paused, completed }

class TimerController extends ChangeNotifier {
  // Ids only. The display names are translated, so they live in the l10n
  // files and are resolved by `AppLocalizations.soundName` at paint time --
  // a controller has no business holding user-visible English.
  static const List<String> tickSoundIds = <String>[
    'tick1', 'tick2', 'tick3', 'tick4', 'tick5', 'tick6',
  ];

  static const List<String> doneSoundIds = <String>[
    'done1', 'done2', 'done3',
  ];

  TimerController({
    required SettingsRepository settingsRepository,
    required WorkoutHistoryRepository historyRepository,
    required AppSettings initialSettings,
    required List<WorkoutRecord> initialHistory,
  })  : _settingsRepository = settingsRepository,
        _historyRepository = historyRepository,
        _settings = initialSettings,
        _history = List<WorkoutRecord>.from(initialHistory);

  final SettingsRepository _settingsRepository;
  final WorkoutHistoryRepository _historyRepository;
  final SoundService _soundService = SoundService();

  AppSettings _settings;
  List<WorkoutRecord> _history;

  int workoutUnits = 60;
  int restSeconds = 10;
  int sets = 5;
  double frequencySeconds = 1.0;

  TimerPhase phase = TimerPhase.idle;
  Timer? _ticker;

  int currentSet = 1;
  int elapsedMs = 0;
  int phaseElapsedMs = 0;
  int remainingPhaseMs = 0;
  bool _pausedFromWorkout = true;
  bool _pausedFromPrestart = false;
  int _lastUnitIndex = 0;
  bool _phaseEndAnnounced = false;
  int _pausedRemainingMs = 0;
  DateTime? _lastTickTime;

  AppSettings get settings => _settings;
  List<WorkoutRecord> get history => List<WorkoutRecord>.unmodifiable(_history);
  bool get isRunning =>
      phase == TimerPhase.prestart ||
      phase == TimerPhase.workout ||
      phase == TimerPhase.rest;
  bool get isPaused => phase == TimerPhase.paused;
  int get totalDurationMs => _computeTotalDurationMs();
  double get progress =>
      totalDurationMs == 0 ? 0 : (elapsedMs / totalDurationMs).clamp(0, 1);

  int get workoutDurationMs =>
      max(1, (workoutUnits * frequencySeconds * 1000).round());

  int get restDurationMs => max(0, restSeconds * 1000);
  int get prestartDurationMs => _settings.prestartSeconds * 1000;
  bool get isActiveSession =>
      phase == TimerPhase.prestart ||
      phase == TimerPhase.workout ||
      phase == TimerPhase.rest ||
      phase == TimerPhase.paused;
  int get remainingSeconds => max(0, (remainingPhaseMs / 1000).ceil());
  int get workoutIntervalsRemaining => max(0, workoutUnits - _lastUnitIndex);

  double get phaseProgress {
    final duration = switch (phase) {
      TimerPhase.prestart => prestartDurationMs,
      TimerPhase.workout => workoutDurationMs,
      TimerPhase.rest => restDurationMs == 0 ? 1 : restDurationMs,
      _ => 1,
    };
    if (duration <= 0) {
      return 0;
    }
    final value = phaseElapsedMs / duration;
    return value.clamp(0, 1).toDouble();
  }

  Future<void> updateSettings(AppSettings value) async {
    _settings = value;
    // Repaint first: persisting and the wakelock call are both slower than a
    // frame, and neither should make the UI wait or be able to skip the
    // notification by throwing.
    notifyListeners();
    await _settingsRepository.save(_settings);
    await _syncWakelock();
  }

  Future<void> startOrPause() async {
    if (isRunning) {
      _pause();
      return;
    }
    if (isPaused) {
      _resume();
      return;
    }
    _startNewSession();
  }

  void setWorkoutUnits(int value) {
    workoutUnits = max(1, value);
    notifyListeners();
  }

  void setRestSeconds(int value) {
    restSeconds = max(0, value);
    notifyListeners();
  }

  void setSets(int value) {
    sets = max(1, value);
    notifyListeners();
  }

  void setFrequency(double value) {
    // Snap to whole hundredths so repeated +/-0.01 steps don't drift.
    final hundredths = max(1, (value * 100).round());
    frequencySeconds = hundredths / 100;
    notifyListeners();
  }


  String get remainingPhaseText {
    final seconds = max(0, (remainingPhaseMs / 1000).ceil());
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> reset() async {
    _stopTicker();
    if (isActiveSession) {
      await _appendRecord(completed: false);
    }
    // On the setup screen (idle), reset values to factory defaults too
    if (phase == TimerPhase.idle) {
      workoutUnits = 60;
      restSeconds = 10;
      sets = 5;
      frequencySeconds = 1.0;
    }
    phase = TimerPhase.idle;
    currentSet = 1;
    elapsedMs = 0;
    phaseElapsedMs = 0;
    remainingPhaseMs = workoutDurationMs;
    _pausedRemainingMs = 0;
    _pausedFromPrestart = false;
    _lastUnitIndex = 0;
    _phaseEndAnnounced = false;
    await _syncWakelock();
    notifyListeners();
  }

  /// Serialises the current settings and history into a backup archive.
  Uint8List createBackup() =>
      BackupService.create(settings: _settings, history: _history);

  /// Replaces settings and history with the contents of [bytes].
  ///
  /// Throws [BackupFormatException] if the file is not a readable backup, in
  /// which case nothing is changed. Any session in progress is abandoned
  /// without being recorded, since the history it would land in is about to be
  /// replaced anyway.
  Future<BackupContents> restoreBackup(Uint8List bytes) async {
    // Parse before touching state so a bad file is a no-op.
    final contents = BackupService.read(bytes);

    _stopTicker();
    phase = TimerPhase.idle;
    currentSet = 1;
    elapsedMs = 0;
    phaseElapsedMs = 0;
    _pausedRemainingMs = 0;
    _pausedFromPrestart = false;
    _lastUnitIndex = 0;
    _phaseEndAnnounced = false;

    _settings = contents.settings;
    _history = List<WorkoutRecord>.from(contents.history);
    remainingPhaseMs = workoutDurationMs;
    notifyListeners();

    await _settingsRepository.save(_settings);
    await _historyRepository.save(_history);
    await _syncWakelock();
    return contents;
  }

  int completedCount() => _history.where((record) => record.completed).length;

  int totalTrainedSeconds() => _history.fold<int>(
      0, (sum, record) => sum + (record.completed ? record.durationSeconds : 0));

  void _startNewSession() {
    _stopTicker();
    final skipPrestart = prestartDurationMs <= 0;
    phase = skipPrestart ? TimerPhase.workout : TimerPhase.prestart;
    currentSet = 1;
    elapsedMs = 0;
    phaseElapsedMs = 0;
    remainingPhaseMs = skipPrestart ? workoutDurationMs : prestartDurationMs;
    _lastUnitIndex = 0;
    _phaseEndAnnounced = false;
    _tickStart();
    _syncWakelock();
    notifyListeners();
    // With no countdown the workout starts immediately, so cue it right away.
    if (skipPrestart && _settings.timerSignalEnabled) {
      _playTickSoundHigher();
    }
  }

  void _pause() {
    _pausedFromWorkout = phase == TimerPhase.workout;
    _pausedFromPrestart = phase == TimerPhase.prestart;
    _pausedRemainingMs = remainingPhaseMs;
    phase = TimerPhase.paused;
    _stopTicker();
    _syncWakelock();
    notifyListeners();
  }

  void _resume() {
    if (_pausedFromPrestart) {
      phase = TimerPhase.prestart;
    } else {
      phase = _pausedFromWorkout ? TimerPhase.workout : TimerPhase.rest;
    }
    remainingPhaseMs = _pausedRemainingMs;
    _tickStart();
    _syncWakelock();
    notifyListeners();
  }

  void _tickStart() {
    _stopTicker();
    _lastTickTime = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), _onTick);
  }

  void _onTick(Timer _) {
    if (!isRunning) {
      return;
    }

    final now = DateTime.now();
    final deltaMs = now.difference(_lastTickTime!).inMilliseconds;
    _lastTickTime = now;

    if (phase != TimerPhase.prestart) {
      elapsedMs += deltaMs;
    }
    phaseElapsedMs += deltaMs;
    remainingPhaseMs = max(0, remainingPhaseMs - deltaMs);

    if (phase == TimerPhase.prestart && remainingPhaseMs <= 0) {
      phase = TimerPhase.workout;
      phaseElapsedMs = 0;
      remainingPhaseMs = workoutDurationMs;
      _lastUnitIndex = 0;
      _phaseEndAnnounced = false;
      notifyListeners();
      // Play shortened tick immediately so user knows workout has started
      if (_settings.timerSignalEnabled) {
        _playTickSoundHigher();
      }
      return;
    }

    if (phase == TimerPhase.workout) {
      _handleWorkoutSignals();
    }

    if (remainingPhaseMs <= 0) {
      _moveToNextPhase();
    }
    notifyListeners();
  }

  void _handleWorkoutSignals() {
    if (_settings.timerSignalEnabled) {
      final unitBoundaryMs = (frequencySeconds * 1000).round();
      final unitIndex = unitBoundaryMs == 0 ? 0 : (phaseElapsedMs ~/ unitBoundaryMs);
      if (unitIndex > _lastUnitIndex && unitIndex < workoutUnits) {
        _lastUnitIndex = unitIndex;
        // Last unit boundary: play lengthened tick to signal end is near
        if (unitIndex == workoutUnits - 1) {
          _playTickSoundLower();
        } else {
          _playTickSound();
        }
      }
    }
  }

  Future<void> _moveToNextPhase() async {
    if (phase == TimerPhase.workout) {
      final isLastSet = currentSet >= sets;
      if (isLastSet) {
        if (!_phaseEndAnnounced) {
          _phaseEndAnnounced = true;
          _playDoneSound();
        }
        await _completeWorkout();
        return;
      }
      // Play start signal again when interval ends (before rest)
      if (_settings.timerSignalEnabled) {
        _playTickSoundHigher();
      }
      phase = TimerPhase.rest;
      phaseElapsedMs = 0;
      remainingPhaseMs = restDurationMs;
      _phaseEndAnnounced = false;
      if (remainingPhaseMs == 0) {
        await _moveToNextPhase();
      }
      return;
    }

    if (phase == TimerPhase.rest) {
      currentSet += 1;
      phase = TimerPhase.workout;
      phaseElapsedMs = 0;
      remainingPhaseMs = workoutDurationMs;
      _lastUnitIndex = 0;
      _phaseEndAnnounced = false;
      // Signal start of new workout set immediately
      if (_settings.timerSignalEnabled) {
        _playTickSoundHigher();
      }
    }
  }

  Future<void> _completeWorkout() async {
    _stopTicker();
    phase = TimerPhase.completed;
    remainingPhaseMs = 0;
    await _syncWakelock();
    await _appendRecord(completed: true);
  }

  Future<void> _appendRecord({required bool completed}) async {
    // elapsedMs already excludes the prestart countdown and any paused time,
    // so it is the real trained duration -- wall clock would overstate it.
    final durationSeconds = max(0, (elapsedMs / 1000).round());
    _history = <WorkoutRecord>[
      WorkoutRecord(
        completedAt: DateTime.now(),
        durationSeconds: durationSeconds,
        workoutUnits: workoutUnits,
        restSeconds: restSeconds,
        sets: sets,
        frequencySeconds: frequencySeconds,
        completed: completed,
      ),
      ..._history,
    ];
    await _historyRepository.save(_history);
    notifyListeners();
  }

  Future<void> _playTickSound() async {
    await _soundService.playTick(_settings.tickSoundId);
  }

  Future<void> _playTickSoundHigher() async {
    await _soundService.playTickHigher(_settings.tickSoundId);
  }

  Future<void> _playTickSoundLower() async {
    await _soundService.playTickLower(_settings.tickSoundId);
  }

  Future<void> _playDoneSound() async {
    await _soundService.playDone(_settings.doneSoundId);
  }

  Future<void> previewTickSound(String soundId) async {
    final next = _settings.copyWith(tickSoundId: soundId);
    await updateSettings(next);
    await _playTickSound();
  }

  Future<void> previewDoneSound(String soundId) async {
    final next = _settings.copyWith(doneSoundId: soundId);
    await updateSettings(next);
    await _playDoneSound();
  }

  int _computeTotalDurationMs() {
    final workoutMs = workoutDurationMs * sets;
    final restPhases = sets > 1 ? sets - 1 : 0;
    final restMs = restDurationMs * restPhases;
    return workoutMs + restMs;
  }

  Future<void> _syncWakelock() async {
    // Best effort only: some devices reject the request, and that must never
    // abort the caller (which would skip its notifyListeners()).
    try {
      if (_settings.keepScreenOn && isRunning) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (_) {
      // Screen may sleep; the session itself is unaffected.
    }
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    _soundService.dispose();
    _syncWakelock();
    super.dispose();
  }
}
