import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../l10n/l10n_ext.dart';
import '../../theme.dart';
import 'training_totals.dart';
import 'workout_record.dart';

/// Bar chart of total training time, bucketed by day, week or month.
///
/// The strip scrolls horizontally and opens pinned to the newest period. Bars
/// keep a fixed readable width instead of being squeezed to fit, because a
/// year of daily bars on a phone would otherwise be under a pixel each.
///
/// No bar carries a value label -- with this many columns there is no room.
/// Tapping one puts its exact total in the header instead.
class TrainingChartCard extends StatefulWidget {
  const TrainingChartCard({super.key, required this.records});

  final List<WorkoutRecord> records;

  @override
  State<TrainingChartCard> createState() => _TrainingChartCardState();
}

class _TrainingChartCardState extends State<TrainingChartCard> {
  static const double _plotHeight = 118;
  static const double _labelHeight = 14;
  static const double _labelGap = 6;

  ChartPeriod _period = ChartPeriod.day;

  /// Held as a bucket start rather than an index, so it cannot point at the
  /// wrong bar after the list is rebuilt.
  DateTime? _selectedStart;

  void _setPeriod(ChartPeriod period) {
    if (period == _period) return;
    HapticFeedback.lightImpact();
    setState(() {
      _period = period;
      _selectedStart = null;
    });
  }

  void _toggleSelection(TrainingBucket bucket) {
    HapticFeedback.selectionClick();
    setState(() => _selectedStart =
        _selectedStart == bucket.start ? null : bucket.start);
  }

  /// Null once the selected period falls outside a rebuilt list.
  TrainingBucket? _findSelected(List<TrainingBucket> buckets) {
    final start = _selectedStart;
    if (start == null) return null;
    for (final bucket in buckets) {
      if (bucket.start == start) return bucket;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final buckets = buildTrainingBuckets(widget.records, _period);
    if (buckets.isEmpty) return const SizedBox.shrink();

    final peak = peakSecondsIn(buckets);
    final selected = _findSelected(buckets);
    final metrics = _metrics[_period]!;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccent.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: kAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(context.l10n.trainingTime,
                  style: const TextStyle(
                    color: kAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          _PeriodSwitch(period: _period, onChanged: _setPeriod),
          const SizedBox(height: 14),
          _Headline(period: _period, buckets: buckets, selected: selected),
          const SizedBox(height: 12),
          SizedBox(
            height: _plotHeight + _labelGap + _labelHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _YAxis(peakSeconds: peak, plotHeight: _plotHeight),
                const SizedBox(width: 6),
                Expanded(
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        height: _plotHeight,
                        child: CustomPaint(painter: _GridPainter()),
                      ),
                      ListView.builder(
                        // A fresh list per period, so switching always lands
                        // back on the newest bar instead of a stale offset.
                        key: ValueKey(_period),
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        itemCount: buckets.length,
                        itemBuilder: (context, index) {
                          final bucket = buckets[index];
                          return _Bar(
                            // Keyed by period start so element identity
                            // follows the bar, not its index.
                            key: ValueKey(bucket.start),
                            bucket: bucket,
                            peakSeconds: peak,
                            metrics: metrics,
                            plotHeight: _plotHeight,
                            labelGap: _labelGap,
                            labelHeight: _labelHeight,
                            dimmed:
                                selected != null && selected.start != bucket.start,
                            onTap: () => _toggleSelection(bucket),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bar geometry ───────────────────────────────────────────────────────────

class _PeriodMetrics {
  const _PeriodMetrics({required this.barWidth, required this.pitch});

  final double barWidth;

  /// Bar plus gap. Wide enough that the axis label under it stays legible.
  final double pitch;
}

const Map<ChartPeriod, _PeriodMetrics> _metrics = {
  ChartPeriod.day: _PeriodMetrics(barWidth: 9, pitch: 16),
  ChartPeriod.week: _PeriodMetrics(barWidth: 12, pitch: 21),
  ChartPeriod.month: _PeriodMetrics(barWidth: 16, pitch: 29),
};

// ── Headline: selected bar, or the whole period ────────────────────────────

class _Headline extends StatelessWidget {
  const _Headline({
    required this.period,
    required this.buckets,
    required this.selected,
  });

  final ChartPeriod period;
  final List<TrainingBucket> buckets;
  final TrainingBucket? selected;

  @override
  Widget build(BuildContext context) {
    final bucket = selected;
    final seconds =
        bucket == null ? totalSecondsIn(buckets) : bucket.totalSeconds;

    final l = context.l10n;

    final String caption;
    if (bucket == null) {
      caption = '${l.periodCount(period, buckets.length)}'
          '  ·  ${l.tapBarForDetail}';
    } else {
      final sessions = bucket.sessionCount;
      caption = '${bucketRangeLabel(bucket)}  ·  '
          '${sessions == 0 ? l.noTraining : l.sessionsCount(sessions)}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.duration(seconds),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: bucket == null ? kTextPrimary : kAccent,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: kTextSub, fontSize: 12),
        ),
      ],
    );
  }
}

/// "Sat, 20 Sep 2026" / "15 – 21 Sep 2026" / "September 2026".
String bucketRangeLabel(TrainingBucket bucket) => switch (bucket.period) {
      ChartPeriod.day => DateFormat('EEE, d MMM y').format(bucket.start),
      ChartPeriod.week => '${DateFormat('d MMM').format(bucket.start)} – '
          '${DateFormat('d MMM y').format(bucket.lastDay)}',
      ChartPeriod.month => DateFormat('MMMM y').format(bucket.start),
    };

/// Short enough to sit under a 16 dp-wide bar. Where a period opens a new
/// month (or year, for the month view) the label names it instead, which
/// turns the axis into a self-labelling calendar strip.
String axisLabelFor(TrainingBucket bucket) => switch (bucket.period) {
      ChartPeriod.day => bucket.start.day == 1
          ? DateFormat('MMM').format(bucket.start)
          : '${bucket.start.day}',
      ChartPeriod.week => bucket.start.day <= 7
          ? DateFormat('MMM').format(bucket.start)
          : '${bucket.start.day}',
      ChartPeriod.month => bucket.start.month == 1
          ? '${bucket.start.year}'
          : DateFormat('MMM').format(bucket.start),
    };

bool isPeriodMarker(TrainingBucket bucket) => switch (bucket.period) {
      ChartPeriod.day => bucket.start.day == 1,
      ChartPeriod.week => bucket.start.day <= 7,
      ChartPeriod.month => bucket.start.month == 1,
    };

// ── Period switch ──────────────────────────────────────────────────────────

class _PeriodSwitch extends StatelessWidget {
  const _PeriodSwitch({required this.period, required this.onChanged});

  final ChartPeriod period;
  final ValueChanged<ChartPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final value in ChartPeriod.values) ...[
          // Expanded, so three buttons always share the width rather than
          // overflowing on a narrow phone.
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(value),
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: value == period ? kAccent : kSurfaceHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      context.l10n.periodButton(value),
                      style: TextStyle(
                        color: value == period ? kBg : kTextSub,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (value != ChartPeriod.values.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

// ── Plot furniture ─────────────────────────────────────────────────────────

class _YAxis extends StatelessWidget {
  const _YAxis({required this.peakSeconds, required this.plotHeight});

  final int peakSeconds;
  final double plotHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: plotHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _Tick(context.l10n.durationCompact(peakSeconds)),
          _Tick(context.l10n.durationCompact(peakSeconds ~/ 2)),
          const _Tick('0'),
        ],
      ),
    );
  }
}

/// One axis tick. Scaled down rather than wrapped: a two-line tick would
/// shift the whole axis off its gridline, and system font scaling makes that
/// reachable on a real device.
class _Tick extends StatelessWidget {
  const _Tick(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(
          color: kTextSub,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kSurfaceHigh
      ..strokeWidth = 1;
    for (final fraction in const [0.0, 0.5, 1.0]) {
      final y = fraction * (size.height - 1) + 0.5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

// ── One bar ────────────────────────────────────────────────────────────────

class _Bar extends StatelessWidget {
  const _Bar({
    super.key,
    required this.bucket,
    required this.peakSeconds,
    required this.metrics,
    required this.plotHeight,
    required this.labelGap,
    required this.labelHeight,
    required this.dimmed,
    required this.onTap,
  });

  final TrainingBucket bucket;
  final int peakSeconds;
  final _PeriodMetrics metrics;
  final double plotHeight;
  final double labelGap;
  final double labelHeight;
  final bool dimmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool trained = bucket.totalSeconds > 0;
    final double fraction =
        peakSeconds <= 0 ? 0 : bucket.totalSeconds / peakSeconds;
    // A trained period always keeps a visible stub, however short it was.
    final double barHeight = trained ? max(3, fraction * plotHeight) : 2;

    final Color barColor = trained
        ? (dimmed ? kAccent.withValues(alpha: 0.3) : kAccent)
        : kSurfaceHigh;
    final bool marker = isPeriodMarker(bucket);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: metrics.pitch,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: plotHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: metrics.barWidth,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: labelGap),
            SizedBox(
              height: labelHeight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  axisLabelFor(bucket),
                  style: TextStyle(
                    color: marker ? kTextPrimary : kTextSub,
                    fontSize: 9,
                    fontWeight: marker ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
