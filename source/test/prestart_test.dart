// Behaviour of the configurable prestart countdown (v1.1).
// Sounds are disabled so the audio plugin is never touched.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:interval_timer/features/settings/app_settings.dart';
import 'package:interval_timer/features/settings/settings_repository.dart';
import 'package:interval_timer/features/statistics/workout_history_repository.dart';
import 'package:interval_timer/features/timer/timer_controller.dart';

TimerController _controller(int prestartSeconds) => TimerController(
      settingsRepository: SettingsRepository(),
      historyRepository: WorkoutHistoryRepository(),
      initialSettings: AppSettings(
        prestartSeconds: prestartSeconds,
        timerSignalEnabled: false,
      ),
      initialHistory: const [],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  test('prestart duration follows the setting', () {
    expect(_controller(0).prestartDurationMs, 0);
    expect(_controller(3).prestartDurationMs, 3000);
    expect(_controller(20).prestartDurationMs, 20000);
  });

  test('a non-zero prestart opens with the countdown', () async {
    final c = _controller(3);
    addTearDown(c.dispose);

    await c.startOrPause();
    expect(c.phase, TimerPhase.prestart);
    expect(c.remainingPhaseMs, 3000);
    expect(c.remainingSeconds, 3);
  });

  test('prestart 0 starts the workout immediately', () async {
    final c = _controller(0);
    addTearDown(c.dispose);

    await c.startOrPause();
    expect(c.phase, TimerPhase.workout);
    expect(c.remainingPhaseMs, c.workoutDurationMs);
    expect(c.currentSet, 1);
  });

  test('frequency snaps to whole hundredths', () {
    final c = _controller(0);
    addTearDown(c.dispose);

    c.setFrequency(1.0);
    for (var i = 0; i < 25; i++) {
      c.setFrequency(c.frequencySeconds - 0.01);
    }
    expect(c.frequencySeconds, closeTo(0.75, 1e-9));
    expect(c.frequencySeconds.toStringAsFixed(2), '0.75');

    // Never drops below one hundredth of a second.
    for (var i = 0; i < 200; i++) {
      c.setFrequency(c.frequencySeconds - 0.01);
    }
    expect(c.frequencySeconds, 0.01);
  });

  test('workout duration tracks units x frequency', () {
    final c = _controller(0);
    addTearDown(c.dispose);

    c.setWorkoutUnits(60);
    c.setFrequency(0.25);
    expect(c.workoutDurationMs, 15000);
  });
}
