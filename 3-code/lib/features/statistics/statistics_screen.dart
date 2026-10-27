import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n_ext.dart';
import '../../theme.dart';
import '../statistics/training_chart.dart';
import '../statistics/workout_record.dart';
import '../timer/timer_controller.dart';

// ── Local aliases for shared tokens ───────────────────────────────────────
const _kBg = kBg;
const _kSurface = kSurface;
const _kSurfaceHigh = kSurfaceHigh;
const _kAccent = kAccent;
const _kTextPrimary = kTextPrimary;
const _kTextSub = kTextSub;

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  // ── Group records by ISO week ────────────────────────────────────────────

  static List<_WeekGroup> _groupByWeek(List<WorkoutRecord> records) {
    final Map<String, _WeekGroup> map = {};
    for (final r in records) {
      final key = _isoWeekKey(r.completedAt);
      map.putIfAbsent(key, () => _WeekGroup(weekStart: _weekStart(r.completedAt)));
      map[key]!.records.add(r);
    }
    final groups = map.values.toList()
      ..sort((a, b) => b.weekStart.compareTo(a.weekStart));
    return groups;
  }

  static String _isoWeekKey(DateTime dt) {
    // Monday of the week
    final monday = dt.subtract(Duration(days: dt.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  static DateTime _weekStart(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day - (dt.weekday - 1));

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TimerController>();
    final records = controller.history;
    final dateFormatter = DateFormat('dd.MM.yyyy HH:mm');
    final weekFormatter = DateFormat('d MMM');

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(
          backgroundColor: _kBg,
          elevation: 0,
          centerTitle: true,
          title: Text(
            context.l10n.statisticsTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _kTextPrimary,
              letterSpacing: 0.5,
            ),
          ),
          iconTheme: const IconThemeData(color: _kTextPrimary),
        ),
        body: records.isEmpty
            ? Center(
                child: Text(context.l10n.noWorkoutsYet,
                    style: const TextStyle(color: _kTextSub, fontSize: 16)))
            : Builder(builder: (context) {
                final weeks = _groupByWeek(records);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    // ── Overall summary card ────────────────────────────
                    _SummaryCard(
                      completedCount: controller.completedCount(),
                      totalSeconds: controller.totalTrainedSeconds(),
                      humanDuration:
                          context.l10n.duration(controller.totalTrainedSeconds()),
                    ),
                    const SizedBox(height: 20),

                    // ── Bar chart by day / week / month ──────────────────
                    TrainingChartCard(records: records),
                    const SizedBox(height: 20),

                    // ── Weekly groups ────────────────────────────────────
                    for (final week in weeks) ...[
                      _WeekHeader(
                        weekStart: week.weekStart,
                        weekFormatter: weekFormatter,
                        thisWeekLabel: context.l10n.thisWeek,
                        lastWeekLabel: context.l10n.lastWeek,
                        totalSeconds: week.totalCompletedSeconds,
                        humanDuration:
                            context.l10n.duration(week.totalCompletedSeconds),
                      ),
                      const SizedBox(height: 8),
                      for (final record in week.records)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _HistoryCard(
                            record: record,
                            formatter: dateFormatter,
                            humanDuration:
                                context.l10n.duration(record.durationSeconds),
                          ),
                        ),
                      const SizedBox(height: 6),
                    ],
                  ],
                );
              }),
      ),
    );
  }
}

// ── Data model ─────────────────────────────────────────────────────────────

class _WeekGroup {
  _WeekGroup({required this.weekStart});
  final DateTime weekStart;
  final List<WorkoutRecord> records = [];

  int get totalCompletedSeconds => records
      .where((r) => r.completed)
      .fold(0, (sum, r) => sum + r.durationSeconds);
}

// ── Summary card ──────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.completedCount,
    required this.totalSeconds,
    required this.humanDuration,
  });

  final int completedCount;
  final int totalSeconds;
  final String humanDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kAccent.withValues(alpha: 0.15), width: 1),
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
                  color: _kAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(context.l10n.overview,
                  style: const TextStyle(
                    color: _kAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('$completedCount',
                        style: const TextStyle(
                            color: _kTextPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800)),
                    Text(context.l10n.completedLabel,
                        style: const TextStyle(
                            color: _kTextSub, fontSize: 12)),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: _kSurfaceHigh),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(humanDuration,
                          style: const TextStyle(
                              color: _kTextPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                      Text(context.l10n.totalSuffix(totalSeconds),
                          style: const TextStyle(
                              color: _kTextSub, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Week header / splitter ─────────────────────────────────────────────────

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.weekStart,
    required this.weekFormatter,
    required this.thisWeekLabel,
    required this.lastWeekLabel,
    required this.totalSeconds,
    required this.humanDuration,
  });

  final DateTime weekStart;
  final DateFormat weekFormatter;

  // Passed in rather than read from context: _weekLabel() is a plain method
  // with no BuildContext of its own.
  final String thisWeekLabel;
  final String lastWeekLabel;
  final int totalSeconds;
  final String humanDuration;

  String _weekLabel() {
    final now = DateTime.now();
    final thisMonday =
        now.subtract(Duration(days: now.weekday - 1));
    final thisWeekStart =
        DateTime(thisMonday.year, thisMonday.month, thisMonday.day);
    final lastWeekStart =
        thisWeekStart.subtract(const Duration(days: 7));

    if (weekStart == thisWeekStart) return thisWeekLabel;
    if (weekStart == lastWeekStart) return lastWeekLabel;

    final weekEnd = weekStart.add(const Duration(days: 6));
    return '${weekFormatter.format(weekStart)} – ${weekFormatter.format(weekEnd)}';
  }

  @override
  Widget build(BuildContext context) {
    // The chip sizes to its text, so it has to be capped: left unbounded it
    // pushes the two rules into negative width, and a Flexible chip is worse
    // still -- it would take only a third of the row however short its label.
    return LayoutBuilder(builder: (context, constraints) {
      final chipMaxWidth =
          (constraints.maxWidth - 64).clamp(0.0, double.infinity);
      return Row(
        children: [
          // Left line
          Expanded(
            child: Container(height: 1, color: _kSurfaceHigh),
          ),
          // Week label chip
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: chipMaxWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _kSurfaceHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _weekLabel(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _kTextSub,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  if (totalSeconds > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                          color: _kTextSub.withValues(alpha: 0.4),
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        humanDuration,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _kAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Right line
          Expanded(
            child: Container(height: 1, color: _kSurfaceHigh),
          ),
        ],
      );
    });
  }
}

// ── History card ──────────────────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.record,
    required this.formatter,
    required this.humanDuration,
  });

  final WorkoutRecord record;
  final DateFormat formatter;
  final String humanDuration;

  @override
  Widget build(BuildContext context) {
    final bool done = record.completed;
    final statusColor = done ? _kAccent : const Color(0xFFFF6B6B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatter.format(record.completedAt),
                  style: const TextStyle(
                    color: _kTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.recordDetail(
                    record.workoutUnits,
                    record.restSeconds,
                    record.sets,
                    record.frequencySeconds.toStringAsFixed(2),
                  ),
                  style: const TextStyle(color: _kTextSub, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(humanDuration,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              Text('${record.durationSeconds}s',
                  style:
                      const TextStyle(color: _kTextSub, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
