import 'package:flutter_test/flutter_test.dart';
import 'package:interval_timer/features/settings/app_settings.dart';
import 'package:interval_timer/features/statistics/workout_record.dart';

void main() {
  group('AppSettings prestart', () {
    test('defaults to 10 s', () {
      expect(const AppSettings().prestartSeconds,
          AppSettings.defaultPrestartSeconds);
    });

    test('copyWith clamps to the 0–20 s range', () {
      const base = AppSettings();
      expect(base.copyWith(prestartSeconds: -5).prestartSeconds, 0);
      expect(base.copyWith(prestartSeconds: 0).prestartSeconds, 0);
      expect(base.copyWith(prestartSeconds: 20).prestartSeconds, 20);
      expect(base.copyWith(prestartSeconds: 99).prestartSeconds, 20);
    });

    test('survives a JSON round trip', () {
      const original = AppSettings(
        keepScreenOn: false,
        showProgressBar: false,
        timerSignalEnabled: false,
        tickSoundId: 'tick4',
        doneSoundId: 'done3',
        prestartSeconds: 3,
      );
      final restored = AppSettings.fromJson(original.toJson());

      expect(restored.keepScreenOn, false);
      expect(restored.showProgressBar, false);
      expect(restored.timerSignalEnabled, false);
      expect(restored.tickSoundId, 'tick4');
      expect(restored.doneSoundId, 'done3');
      expect(restored.prestartSeconds, 3);
    });

    test('settings saved before v1.1 fall back to the default', () {
      final legacy = AppSettings.fromJson(const <String, Object?>{
        'keepScreenOn': true,
        'tickSoundId': 'tick2',
      });
      expect(legacy.prestartSeconds, AppSettings.defaultPrestartSeconds);
      expect(legacy.tickSoundId, 'tick2');
    });

    test('out-of-range stored values are clamped on read', () {
      final tampered =
          AppSettings.fromJson(const <String, Object?>{'prestartSeconds': 500});
      expect(tampered.prestartSeconds, AppSettings.maxPrestartSeconds);
    });
  });

  group('WorkoutRecord', () {
    test('keeps sub-second frequency through a JSON round trip', () {
      final original = WorkoutRecord(
        completedAt: DateTime(2026, 5, 7, 18, 30),
        durationSeconds: 325,
        workoutUnits: 60,
        restSeconds: 10,
        sets: 5,
        frequencySeconds: 0.75,
        completed: true,
      );
      final restored = WorkoutRecord.fromJson(original.toJson());

      expect(restored.completedAt, original.completedAt);
      expect(restored.durationSeconds, 325);
      expect(restored.frequencySeconds, 0.75);
      expect(restored.completed, true);
    });
  });
}
