// Backup archive format and restore behaviour (v1.1).
import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:interval_timer/features/backup/backup_service.dart';
import 'package:interval_timer/features/settings/app_settings.dart';
import 'package:interval_timer/features/settings/settings_repository.dart';
import 'package:interval_timer/features/statistics/workout_history_repository.dart';
import 'package:interval_timer/features/statistics/workout_record.dart';
import 'package:interval_timer/features/timer/timer_controller.dart';

const _settings = AppSettings(
  keepScreenOn: false,
  showProgressBar: false,
  timerSignalEnabled: false,
  tickSoundId: 'tick5',
  doneSoundId: 'done2',
  prestartSeconds: 7,
);

final _history = <WorkoutRecord>[
  WorkoutRecord(
    completedAt: DateTime(2026, 9, 20, 7, 30),
    durationSeconds: 412,
    workoutUnits: 45,
    restSeconds: 15,
    sets: 4,
    frequencySeconds: 0.75,
    completed: true,
  ),
  WorkoutRecord(
    completedAt: DateTime(2026, 9, 19, 18, 5),
    durationSeconds: 96,
    workoutUnits: 60,
    restSeconds: 10,
    sets: 5,
    frequencySeconds: 1.0,
    completed: false,
  ),
];

/// Builds a zip with exactly the entries given, for the malformed-input cases.
Uint8List _zipOf(Map<String, String> entries) {
  final archive = Archive();
  entries.forEach((name, body) => archive.add(ArchiveFile.string(name, body)));
  return Uint8List.fromList(ZipEncoder().encode(archive));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  group('archive round trip', () {
    test('settings and history survive export then import', () {
      final bytes = BackupService.create(settings: _settings, history: _history);
      final restored = BackupService.read(bytes);

      expect(restored.settings.keepScreenOn, false);
      expect(restored.settings.showProgressBar, false);
      expect(restored.settings.timerSignalEnabled, false);
      expect(restored.settings.tickSoundId, 'tick5');
      expect(restored.settings.doneSoundId, 'done2');
      expect(restored.settings.prestartSeconds, 7);

      expect(restored.history, hasLength(2));
      expect(restored.history.first.completedAt, DateTime(2026, 9, 20, 7, 30));
      expect(restored.history.first.durationSeconds, 412);
      expect(restored.history.first.frequencySeconds, 0.75);
      expect(restored.history.first.completed, true);
      expect(restored.history.last.completed, false);
    });

    test('order is preserved', () {
      final bytes = BackupService.create(settings: _settings, history: _history);
      final restored = BackupService.read(bytes);
      expect(
        restored.history.map((r) => r.completedAt).toList(),
        _history.map((r) => r.completedAt).toList(),
      );
    });

    test('an empty history round trips', () {
      final bytes =
          BackupService.create(settings: const AppSettings(), history: const []);
      final restored = BackupService.read(bytes);
      expect(restored.history, isEmpty);
      expect(restored.settings.prestartSeconds,
          AppSettings.defaultPrestartSeconds);
    });

    test('manifest records provenance and counts', () {
      final stamp = DateTime(2026, 9, 21, 18, 15);
      final bytes = BackupService.create(
          settings: _settings, history: _history, now: stamp);

      final archive = ZipDecoder().decodeBytes(bytes);
      final manifest = jsonDecode(
              utf8.decode(archive.find(BackupService.manifestEntry)!.content))
          as Map<String, Object?>;

      expect(manifest['schemaVersion'], BackupService.schemaVersion);
      expect(manifest['appVersion'], BackupService.appVersion);
      expect(manifest['workoutCount'], 2);
      expect(manifest['completedCount'], 1);
      expect(DateTime.parse(manifest['exportedAt']! as String), stamp);

      final restored = BackupService.read(bytes);
      expect(restored.exportedAt, stamp);
      expect(restored.appVersion, BackupService.appVersion);
    });

    test('archive holds exactly the three documented entries', () {
      final bytes = BackupService.create(settings: _settings, history: _history);
      final names = ZipDecoder().decodeBytes(bytes).map((f) => f.name).toSet();
      expect(
        names,
        {
          BackupService.manifestEntry,
          BackupService.settingsEntry,
          BackupService.historyEntry,
        },
      );
    });

    test('suggested file name is sortable and zip-suffixed', () {
      final name = BackupService.suggestedFileName(DateTime(2026, 9, 21, 8, 5));
      expect(name, 'interval-timer-backup-2026-09-21_0805.zip');
    });
  });

  group('rejects bad input', () {
    test('a file that is not a zip', () {
      expect(
        () => BackupService.read(Uint8List.fromList(utf8.encode('hello'))),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('a zip with no manifest', () {
      expect(
        () => BackupService.read(_zipOf({'notes.txt': 'hi'})),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('a backup written by a newer app version', () {
      final bytes = _zipOf({
        BackupService.manifestEntry:
            jsonEncode({'schemaVersion': BackupService.schemaVersion + 1}),
        BackupService.settingsEntry: jsonEncode(const AppSettings().toJson()),
        BackupService.historyEntry: '[]',
      });
      expect(
        () => BackupService.read(bytes),
        throwsA(isA<BackupFormatException>().having(
            (e) => e.message, 'message', contains('newer version'))),
      );
    });

    test('a manifest with no schema version', () {
      final bytes = _zipOf({
        BackupService.manifestEntry: jsonEncode({'appVersion': '1.1.0+2'}),
        BackupService.settingsEntry: jsonEncode(const AppSettings().toJson()),
        BackupService.historyEntry: '[]',
      });
      expect(() => BackupService.read(bytes),
          throwsA(isA<BackupFormatException>()));
    });

    test('an archive missing history.json', () {
      final bytes = _zipOf({
        BackupService.manifestEntry: jsonEncode({'schemaVersion': 1}),
        BackupService.settingsEntry: jsonEncode(const AppSettings().toJson()),
      });
      expect(
        () => BackupService.read(bytes),
        throwsA(isA<BackupFormatException>()
            .having((e) => e.message, 'message', contains('incomplete'))),
      );
    });

    test('history that is not a list', () {
      final bytes = _zipOf({
        BackupService.manifestEntry: jsonEncode({'schemaVersion': 1}),
        BackupService.settingsEntry: jsonEncode(const AppSettings().toJson()),
        BackupService.historyEntry: jsonEncode({'oops': true}),
      });
      expect(() => BackupService.read(bytes),
          throwsA(isA<BackupFormatException>()));
    });

    test('malformed JSON', () {
      final bytes = _zipOf({
        BackupService.manifestEntry: '{not json',
        BackupService.settingsEntry: '{}',
        BackupService.historyEntry: '[]',
      });
      expect(() => BackupService.read(bytes),
          throwsA(isA<BackupFormatException>()));
    });

    test('one damaged row is skipped, the rest survive', () {
      final bytes = _zipOf({
        BackupService.manifestEntry: jsonEncode({'schemaVersion': 1}),
        BackupService.settingsEntry: jsonEncode(const AppSettings().toJson()),
        BackupService.historyEntry: jsonEncode([
          _history.first.toJson(),
          {'completedAt': 'not-a-date'},
          _history.last.toJson(),
        ]),
      });

      final restored = BackupService.read(bytes);
      expect(restored.history, hasLength(2));
      expect(restored.history.first.durationSeconds, 412);
      expect(restored.history.last.durationSeconds, 96);
    });
  });

  group('controller restore', () {
    TimerController build() => TimerController(
          settingsRepository: SettingsRepository(),
          historyRepository: WorkoutHistoryRepository(),
          initialSettings: const AppSettings(timerSignalEnabled: false),
          initialHistory: const [],
        );

    test('replaces settings and history', () async {
      final c = build();
      addTearDown(c.dispose);

      expect(c.history, isEmpty);
      expect(c.settings.prestartSeconds, 10);

      final contents = await c.restoreBackup(
          BackupService.create(settings: _settings, history: _history));

      expect(contents.history, hasLength(2));
      expect(c.history, hasLength(2));
      expect(c.settings.prestartSeconds, 7);
      expect(c.settings.tickSoundId, 'tick5');
      expect(c.completedCount(), 1);
      expect(c.totalTrainedSeconds(), 412);
    });

    test('a bad archive changes nothing', () async {
      final c = build();
      addTearDown(c.dispose);

      await c.restoreBackup(
          BackupService.create(settings: _settings, history: _history));
      expect(c.history, hasLength(2));

      await expectLater(
        c.restoreBackup(Uint8List.fromList(utf8.encode('garbage'))),
        throwsA(isA<BackupFormatException>()),
      );

      // Untouched by the failed attempt.
      expect(c.history, hasLength(2));
      expect(c.settings.prestartSeconds, 7);
    });

    test('restoring abandons a session in progress without recording it',
        () async {
      final c = build();
      addTearDown(c.dispose);

      await c.startOrPause();
      expect(c.isActiveSession, isTrue);

      await c.restoreBackup(
          BackupService.create(settings: _settings, history: _history));

      expect(c.phase, TimerPhase.idle);
      expect(c.isActiveSession, isFalse);
      // Exactly the two restored rows — no incomplete record was appended.
      expect(c.history, hasLength(2));
    });

    test('an exported backup reloads into a fresh controller', () async {
      final source = build();
      addTearDown(source.dispose);
      await source.restoreBackup(
          BackupService.create(settings: _settings, history: _history));

      final target = build();
      addTearDown(target.dispose);
      await target.restoreBackup(source.createBackup());

      expect(target.history, hasLength(2));
      expect(target.settings.tickSoundId, 'tick5');
      expect(target.settings.prestartSeconds, 7);
      expect(target.history.first.frequencySeconds, 0.75);
    });
  });
}
