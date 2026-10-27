// Calendar bucketing behind the Statistics bar charts (v1.3).
import 'package:flutter_test/flutter_test.dart';

import 'package:interval_timer/features/statistics/training_totals.dart';
import 'package:interval_timer/features/statistics/workout_record.dart';

/// English wording, so these tests keep asserting the composition rules --
/// which units show, in what order -- rather than any one translation.
class _EnWords implements DurationWords {
  const _EnWords();
  @override
  String hour(int n) => '$n h';
  @override
  String minute(int n) => '$n min';
  @override
  String second(int n) => '$n sec';
  @override
  String get none => '—';
  @override
  String compactHour(String n) => '$n h';
  @override
  String compactMinute(int n) => '$n m';
  @override
  String compactSecond(int n) => '$n s';
}

const _w = _EnWords();

/// 2026-09-21 is a Monday, so "today" is also the start of its week.
final _now = DateTime(2026, 9, 21, 19, 30);

WorkoutRecord _record(DateTime at, int seconds, {bool completed = true}) =>
    WorkoutRecord(
      completedAt: at,
      durationSeconds: seconds,
      workoutUnits: 45,
      restSeconds: 15,
      sets: 4,
      frequencySeconds: 1.0,
      completed: completed,
    );

void main() {
  group('bucket boundaries', () {
    test('a day starts at midnight', () {
      expect(bucketStartFor(DateTime(2026, 9, 21, 23, 59), ChartPeriod.day),
          DateTime(2026, 9, 21));
    });

    test('a week starts on Monday, so a Sunday falls in the week before it', () {
      // Sun 20 Sep 2026 belongs to the week beginning Mon 14 Sep.
      expect(bucketStartFor(DateTime(2026, 9, 20, 7, 30), ChartPeriod.week),
          DateTime(2026, 9, 14));
      expect(bucketStartFor(DateTime(2026, 9, 21, 7, 30), ChartPeriod.week),
          DateTime(2026, 9, 21));
    });

    test('a month starts on the first', () {
      expect(bucketStartFor(DateTime(2026, 9, 30, 12), ChartPeriod.month),
          DateTime(2026, 9));
    });

    test('steps roll over month and year ends', () {
      expect(nextBucketStart(DateTime(2026, 8, 31), ChartPeriod.day),
          DateTime(2026, 9, 1));
      expect(previousBucketStart(DateTime(2026, 9, 1), ChartPeriod.day),
          DateTime(2026, 8, 31));
      expect(nextBucketStart(DateTime(2026, 12, 28), ChartPeriod.week),
          DateTime(2027, 1, 4));
      expect(previousBucketStart(DateTime(2026, 1), ChartPeriod.month),
          DateTime(2025, 12));
    });
  });

  group('day buckets', () {
    test('no records means no chart', () {
      expect(buildTrainingBuckets(const [], ChartPeriod.day, now: _now),
          isEmpty);
    });

    test('runs newest first, from the oldest record up to today', () {
      final buckets = buildTrainingBuckets(
        [_record(DateTime(2026, 9, 18, 8), 300)],
        ChartPeriod.day,
        now: _now,
      );

      // 18th, 19th, 20th, 21st.
      expect(buckets, hasLength(4));
      expect(buckets.first.start, DateTime(2026, 9, 21));
      expect(buckets.last.start, DateTime(2026, 9, 18));
      expect(buckets.last.totalSeconds, 300);
    });

    test('days without training are kept as empty bars', () {
      final buckets = buildTrainingBuckets(
        [
          _record(DateTime(2026, 9, 21, 8), 120),
          _record(DateTime(2026, 9, 18, 8), 300),
        ],
        ChartPeriod.day,
        now: _now,
      );

      expect(buckets.map((b) => b.totalSeconds).toList(), [120, 0, 0, 300]);
      expect(buckets[1].hasTraining, isFalse);
      expect(buckets[1].sessionCount, 0);
    });

    test('several sessions in one day are summed and counted', () {
      final buckets = buildTrainingBuckets(
        [
          _record(DateTime(2026, 9, 21, 7), 100),
          _record(DateTime(2026, 9, 21, 19), 250),
        ],
        ChartPeriod.day,
        now: _now,
      );

      expect(buckets, hasLength(1));
      expect(buckets.single.totalSeconds, 350);
      expect(buckets.single.sessionCount, 2);
    });

    test('consecutive buckets are exactly one calendar day apart', () {
      final buckets = buildTrainingBuckets(
        [_record(DateTime(2026, 8, 29, 8), 60)],
        ChartPeriod.day,
        now: _now,
      );

      for (var i = 0; i < buckets.length - 1; i++) {
        expect(buckets[i].start, nextBucketStart(buckets[i + 1].start,
            ChartPeriod.day));
      }
      expect(buckets.map((b) => b.start).toSet(), hasLength(buckets.length));
    });
  });

  group('week and month buckets', () {
    test('weeks are Monday-aligned and gap-filled', () {
      final buckets = buildTrainingBuckets(
        [
          _record(DateTime(2026, 9, 20, 18), 400), // Sun -> week of 14 Sep
          _record(DateTime(2026, 8, 31, 9), 200), // Mon -> week of 31 Aug
        ],
        ChartPeriod.week,
        now: _now,
      );

      expect(buckets.map((b) => b.start).toList(), [
        DateTime(2026, 9, 21),
        DateTime(2026, 9, 14),
        DateTime(2026, 9, 7),
        DateTime(2026, 8, 31),
      ]);
      expect(buckets.map((b) => b.totalSeconds).toList(), [0, 400, 0, 200]);
    });

    test('a week bucket reports its inclusive last day', () {
      final buckets = buildTrainingBuckets(
        [_record(DateTime(2026, 9, 20, 18), 400)],
        ChartPeriod.week,
        now: _now,
      );
      final week = buckets.firstWhere((b) => b.start == DateTime(2026, 9, 14));
      expect(week.lastDay, DateTime(2026, 9, 20));
    });

    test('months span a year boundary', () {
      final buckets = buildTrainingBuckets(
        [_record(DateTime(2025, 12, 5, 8), 900)],
        ChartPeriod.month,
        now: _now,
      );

      expect(buckets.first.start, DateTime(2026, 9));
      expect(buckets.last.start, DateTime(2025, 12));
      expect(buckets, hasLength(10)); // Dec 2025 .. Sep 2026
      expect(buckets.last.totalSeconds, 900);
      expect(buckets.last.lastDay, DateTime(2025, 12, 31));
    });
  });

  group('totals reconcile with the Overview card', () {
    final history = [
      _record(DateTime(2026, 9, 21, 7), 412),
      _record(DateTime(2026, 9, 20, 18), 96, completed: false),
      _record(DateTime(2026, 9, 3, 6), 1500),
    ];

    test('every period sums to the same total, abandoned sessions included',
        () {
      const expected = 412 + 96 + 1500;
      for (final period in ChartPeriod.values) {
        final buckets = buildTrainingBuckets(history, period, now: _now);
        expect(totalSecondsIn(buckets), expected, reason: '$period');
      }
    });

    test('the peak sets the axis scale', () {
      final buckets = buildTrainingBuckets(history, ChartPeriod.day, now: _now);
      expect(peakSecondsIn(buckets), 1500);
      expect(peakSecondsIn(const []), 0);
    });
  });

  group('hostile data', () {
    test('a record stamped in the future still appears', () {
      final buckets = buildTrainingBuckets(
        [_record(DateTime(2026, 9, 24, 8), 60)],
        ChartPeriod.day,
        now: _now,
      );

      expect(buckets.first.start, DateTime(2026, 9, 24));
      expect(totalSecondsIn(buckets), 60);
    });

    test('a negative duration counts as zero, not as a negative bar', () {
      final buckets = buildTrainingBuckets(
        [_record(DateTime(2026, 9, 21, 8), -50)],
        ChartPeriod.day,
        now: _now,
      );
      expect(buckets.single.totalSeconds, 0);
      expect(buckets.single.sessionCount, 1);
    });

    test('a corrupt far-past date cannot produce unbounded columns', () {
      final buckets = buildTrainingBuckets(
        [
          _record(DateTime(2026, 9, 21, 8), 60),
          _record(DateTime(1970, 1, 1), 60),
        ],
        ChartPeriod.day,
        now: _now,
        maxBuckets: 30,
      );

      expect(buckets, hasLength(30));
      // Truncation drops the oldest, never the newest.
      expect(buckets.first.start, DateTime(2026, 9, 21));
    });
  });

  group('wording', () {
    test('humanDuration matches the Statistics phrasing', () {
      expect(humanDuration(0, _w), '—');
      expect(humanDuration(-5, _w), '—');
      expect(humanDuration(45, _w), '45 sec');
      expect(humanDuration(412, _w), '6 min 52 sec');
      expect(humanDuration(3600, _w), '1 h');
      expect(humanDuration(3725, _w), '1 h 2 min 5 sec');
    });

    test('compactDuration fits an axis tick', () {
      expect(compactDuration(0, _w), '0');
      expect(compactDuration(30, _w), '30 s');
      expect(compactDuration(90, _w), '1 m');
      expect(compactDuration(3600, _w), '1 h');
      expect(compactDuration(5400, _w), '1.5 h');
      expect(compactDuration(36000, _w), '10 h');
    });

    test('an empty total reads as a dash, not "0 sec"', () {
      expect(humanDuration(0, _w), '—');
      expect(compactDuration(0, _w), '0');
    });
  });
}
