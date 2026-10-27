// Calendar bucketing and duration wording for the Statistics bar charts.
//
// Deliberately free of Flutter imports: every rule that is easy to get wrong
// -- which day a session lands in, how far the axis runs, what a period with
// no training looks like -- is unit tested here without a widget tree.
import 'dart:math';

import 'workout_record.dart';

/// The calendar unit one bar covers.
enum ChartPeriod { day, week, month }



/// One bar: a calendar period and the training time recorded inside it.
class TrainingBucket {
  const TrainingBucket({
    required this.start,
    required this.period,
    required this.totalSeconds,
    required this.sessionCount,
  });

  final DateTime start;
  final ChartPeriod period;

  /// Sum of every session in this period, completed or abandoned, so the
  /// chart reconciles with the "total" on the Overview card above it.
  final int totalSeconds;
  final int sessionCount;

  /// Exclusive end -- the start of the next period.
  DateTime get end => nextBucketStart(start, period);

  /// Inclusive last day, for "15 - 21 Sep" style range labels.
  DateTime get lastDay => DateTime(end.year, end.month, end.day - 1);

  bool get hasTraining => sessionCount > 0;
}

/// The period [dt] falls in. Weeks start Monday, matching the week headers
/// further down the Statistics screen.
DateTime bucketStartFor(DateTime dt, ChartPeriod period) => switch (period) {
      ChartPeriod.day => DateTime(dt.year, dt.month, dt.day),
      ChartPeriod.week => DateTime(dt.year, dt.month, dt.day - (dt.weekday - 1)),
      ChartPeriod.month => DateTime(dt.year, dt.month),
    };

// Both steps go through the DateTime(y, m, d) constructor, which normalises
// out-of-range components. That rolls over month and year ends for free and,
// unlike Duration arithmetic, cannot drift an hour across a DST boundary.

DateTime nextBucketStart(DateTime start, ChartPeriod period) =>
    switch (period) {
      ChartPeriod.day => DateTime(start.year, start.month, start.day + 1),
      ChartPeriod.week => DateTime(start.year, start.month, start.day + 7),
      ChartPeriod.month => DateTime(start.year, start.month + 1),
    };

DateTime previousBucketStart(DateTime start, ChartPeriod period) =>
    switch (period) {
      ChartPeriod.day => DateTime(start.year, start.month, start.day - 1),
      ChartPeriod.week => DateTime(start.year, start.month, start.day - 7),
      ChartPeriod.month => DateTime(start.year, start.month - 1),
    };

/// Every period from the oldest record up to the one containing [now],
/// **newest first** -- index 0 is "today", so the chart can open pinned to it.
///
/// Periods with no training are kept as zero-valued buckets: skipping them
/// would compress the axis and hide how regular the training actually was.
///
/// [maxBuckets] only guards against a corrupt far-past timestamp turning the
/// day view into tens of thousands of columns; at the default it holds over a
/// decade of daily bars, so real histories are never truncated.
List<TrainingBucket> buildTrainingBuckets(
  Iterable<WorkoutRecord> records,
  ChartPeriod period, {
  DateTime? now,
  int maxBuckets = 4000,
}) {
  final nowStart = bucketStartFor(now ?? DateTime.now(), period);
  final totals = <DateTime, int>{};
  final counts = <DateTime, int>{};

  var oldest = nowStart;
  var newest = nowStart;
  for (final record in records) {
    final key = bucketStartFor(record.completedAt, period);
    totals[key] = (totals[key] ?? 0) + max(0, record.durationSeconds);
    counts[key] = (counts[key] ?? 0) + 1;
    if (key.isBefore(oldest)) oldest = key;
    // A record stamped in the future (clock change, restored backup) still has
    // to appear, or the bars would stop adding up to the Overview total.
    if (key.isAfter(newest)) newest = key;
  }
  if (totals.isEmpty) return const <TrainingBucket>[];

  final buckets = <TrainingBucket>[];
  var cursor = newest;
  while (!cursor.isBefore(oldest) && buckets.length < maxBuckets) {
    buckets.add(TrainingBucket(
      start: cursor,
      period: period,
      totalSeconds: totals[cursor] ?? 0,
      sessionCount: counts[cursor] ?? 0,
    ));
    cursor = previousBucketStart(cursor, period);
  }
  return buckets;
}

int totalSecondsIn(Iterable<TrainingBucket> buckets) =>
    buckets.fold<int>(0, (sum, bucket) => sum + bucket.totalSeconds);

/// Tallest bar, which sets the y-axis scale.
int peakSecondsIn(Iterable<TrainingBucket> buckets) =>
    buckets.fold<int>(0, (peak, bucket) => max(peak, bucket.totalSeconds));

/// The unit words a duration is built from. Supplied by the UI so this file
/// stays free of Flutter and of any one language; the composition rules --
/// which units appear, in what order, when a zero is dropped -- are what is
/// worth testing, and they are identical in every language the app offers.
abstract interface class DurationWords {
  String hour(int n);
  String minute(int n);
  String second(int n);

  /// Shown instead of "0 sec" for an empty total.
  String get none;

  /// Axis-tick forms: "2 h", "1.5 h", "45 m", "30 s".
  String compactHour(String n);
  String compactMinute(int n);
  String compactSecond(int n);
}

/// "1 h 20 min 5 sec" -- the wording used throughout Statistics.
String humanDuration(int totalSeconds, DurationWords words) {
  if (totalSeconds <= 0) return words.none;
  final h = totalSeconds ~/ 3600;
  final m = (totalSeconds % 3600) ~/ 60;
  final s = totalSeconds % 60;
  final parts = <String>[];
  if (h > 0) parts.add(words.hour(h));
  if (m > 0) parts.add(words.minute(m));
  if (s > 0) parts.add(words.second(s));
  return parts.join(' ');
}

/// Axis-tick sized: "2 h", "1.5 h", "45 m", "30 s".
String compactDuration(int totalSeconds, DurationWords words) {
  if (totalSeconds <= 0) return '0';
  if (totalSeconds >= 3600) {
    final hours = totalSeconds / 3600;
    return hours >= 10 || hours == hours.roundToDouble()
        ? words.compactHour('${hours.round()}')
        : words.compactHour(hours.toStringAsFixed(1));
  }
  if (totalSeconds >= 60) return words.compactMinute(totalSeconds ~/ 60);
  return words.compactSecond(totalSeconds);
}
