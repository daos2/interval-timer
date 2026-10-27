import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';
import '../info/info_screen.dart';
import 'timer_controller.dart';

// ── Local aliases for shared tokens ───────────────────────────────────────

const _kBg = kBg;
const _kSurface = kSurface;
const _kSurfaceHigh = kSurfaceHigh;
const _kAccent = kAccent;
const _kDanger = kDanger;
const _kDangerDim = kDangerDim;
const _kTextPrimary = kTextPrimary;
const _kTextSub = kTextSub;

// ── Root screen ────────────────────────────────────────────────────────────

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TimerController>();
    if (controller.isActiveSession || controller.phase == TimerPhase.completed) {
      return _ActiveTimerView(controller: controller);
    }
    return _IdleScreen(controller: controller);
  }
}

// ── Idle / setup screen ────────────────────────────────────────────────────

class _IdleScreen extends StatelessWidget {
  const _IdleScreen({required this.controller});
  final TimerController controller;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(
          backgroundColor: _kBg,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Interval Timer',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: _kTextPrimary,
              letterSpacing: 0.5,
            ),
          ),
          actions: const [InfoButton(), SizedBox(width: 4)],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            // Workout interval — 6 buttons: [-60][-5][-1] value [+1][+5][+60]
            _StepperCard(
              label: 'WORKOUT INTERVAL',
              unit: 'units',
              value: controller.workoutUnits.toString(),
              steps: const [-60, -5, -1, 1, 5, 60],
              accentColor: const Color(0xFF70E000),
              accentDim: const Color(0xFF1A3000),
              onStep: (delta) =>
                  controller.setWorkoutUnits(controller.workoutUnits + delta),
            ),
            const SizedBox(height: 10),
            // Rest interval — 6 buttons: [-60][-5][-1] value [+1][+5][+60]
            _StepperCard(
              label: 'REST INTERVAL',
              unit: 'sec',
              value: controller.restSeconds.toString(),
              steps: const [-60, -5, -1, 1, 5, 60],
              accentColor: const Color(0xFFFFA62B),
              accentDim: const Color(0xFF3D2000),
              onStep: (delta) =>
                  controller.setRestSeconds(controller.restSeconds + delta),
            ),
            const SizedBox(height: 10),
            _StepperCard(
              label: 'SETS',
              unit: '',
              value: controller.sets.toString(),
              steps: const [-5, -1, 1, 5],
              accentColor: const Color(0xFF5DA9E9),
              accentDim: const Color(0xFF0D2540),
              onStep: (delta) => controller.setSets(controller.sets + delta),
            ),
            const SizedBox(height: 10),
            _StepperCard(
              label: 'FREQUENCY',
              unit: 'sec',
              value: controller.frequencySeconds.toStringAsFixed(2),
              // Steps are expressed in hundredths of a second.
              steps: const [-100, -10, 10, 100],
              accentColor: const Color(0xFFBB86FC),
              accentDim: const Color(0xFF2A1540),
              onStep: (delta) => controller
                  .setFrequency(controller.frequencySeconds + delta * 0.01),
              stepLabels: const ['-1.0', '-0.1', '+0.1', '+1.0'],
              fineSteps: const [-1, 1],
              fineStepLabels: const ['-0.01', '+0.01'],
            ),
            const SizedBox(height: 20),

            // ── Summary row ────────────────────────────────────────────────
            _SummaryRow(controller: controller),
            const SizedBox(height: 20),

            // ── Action buttons side-by-side ────────────────────────────────
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _ActionButton(
                    label: controller.startButtonLabel,
                    onTap: controller.startOrPause,
                    filled: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _ActionButton(
                    label: 'RESET',
                    onTap: controller.reset,
                    filled: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stepper card ───────────────────────────────────────────────────────────

class _StepperCard extends StatelessWidget {
  const _StepperCard({
    required this.label,
    required this.unit,
    required this.value,
    required this.steps,
    required this.accentColor,
    required this.accentDim,
    required this.onStep,
    this.stepLabels,
    this.fineSteps,
    this.fineStepLabels,
  });

  final String label;
  final String unit;
  final String value;
  final List<int> steps;
  final Color accentColor;
  final Color accentDim;
  final ValueChanged<int> onStep;
  final List<String>? stepLabels;

  /// Optional smaller steps rendered on a second, centred row underneath.
  final List<int>? fineSteps;
  final List<String>? fineStepLabels;

  @override
  Widget build(BuildContext context) {
    final half = steps.length ~/ 2;
    final leftSteps = steps.sublist(0, half);
    final rightSteps = steps.sublist(half);
    final leftLabels = stepLabels?.sublist(0, half);
    final rightLabels = stepLabels?.sublist(half);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: accentColor.withValues(alpha: 0.85),
                  fontSize: 13, // +2 from original 11
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Buttons + value row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left (negative) buttons — rightmost is closest to center
              ...leftSteps.asMap().entries.map((e) => Flexible(
                    child: _StepBtn(
                      label: leftLabels != null
                          ? leftLabels[e.key]
                          : '${e.value}',
                      isNegative: true,
                      accentColor: accentColor,
                      accentDim: accentDim,
                      onTap: () => onStep(e.value),
                    ),
                  )),

              // Value display
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: _kTextPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    if (unit.isNotEmpty)
                      Text(
                        unit,
                        style: const TextStyle(
                          color: _kTextSub,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              // Right (positive) buttons — leftmost is closest to center
              ...rightSteps.asMap().entries.map((e) => Flexible(
                    child: _StepBtn(
                      label: rightLabels != null
                          ? rightLabels[e.key]
                          : '+${e.value}',
                      isNegative: false,
                      accentColor: accentColor,
                      accentDim: accentDim,
                      onTap: () => onStep(e.value),
                    ),
                  )),
            ],
          ),

          // Fine-tune row (e.g. +/-0.01 s), centred under the main controls
          if (fineSteps != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...fineSteps!.asMap().entries.map((e) => _StepBtn(
                      label: fineStepLabels != null
                          ? fineStepLabels![e.key]
                          : '${e.value}',
                      isNegative: e.value < 0,
                      accentColor: accentColor,
                      accentDim: accentDim,
                      onTap: () => onStep(e.value),
                    )),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Step button ────────────────────────────────────────────────────────────

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.label,
    required this.isNegative,
    required this.accentColor,
    required this.accentDim,
    required this.onTap,
  });

  final String label;
  final bool isNegative;
  final Color accentColor;
  final Color accentDim;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isNegative ? _kDangerDim : accentDim;
    final fg = isNegative ? _kDanger : accentColor;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 13, // +1 from original 12
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Summary row ────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.controller});
  final TimerController controller;

  String _fmtDuration(int ms) {
    final totalSec = (ms / 1000).round();
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    if (m == 0) return '${s}s';
    if (s == 0) return '${m}m';
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      ('TOTAL', _fmtDuration(controller.totalDurationMs)),
      ('SETS', '${controller.sets}'),
      ('WORK', _fmtDuration(controller.workoutDurationMs)),
      ('REST', '${controller.restSeconds}s'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: _kSurfaceHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items
            .map((e) => Column(
                  children: [
                    Text(e.$1,
                        style: const TextStyle(
                            color: _kTextSub,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Text(e.$2,
                        style: const TextStyle(
                            color: _kTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

// ── Action button ──────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return SizedBox(
        height: 58,
        child: FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            onTap();
          },
          style: FilledButton.styleFrom(
            backgroundColor: _kAccent,
            foregroundColor: _kBg,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ),
      );
    }
    return SizedBox(
      height: 58,
      child: OutlinedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: _kTextSub,
          side: const BorderSide(color: _kSurfaceHigh, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1)),
      ),
    );
  }
}

// ── Active timer view ──────────────────────────────────────────────────────

class _ActiveTimerView extends StatelessWidget {
  const _ActiveTimerView({required this.controller});
  final TimerController controller;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, ringColor) = switch (controller.phase) {
      TimerPhase.prestart => (const Color(0xFF132A4A), const Color(0xFF5DA9E9)),
      TimerPhase.workout => (const Color(0xFF123524), const Color(0xFF70E000)),
      TimerPhase.rest => (const Color(0xFF402218), const Color(0xFFFFA62B)),
      TimerPhase.paused => (const Color(0xFF1E2730), const Color(0xFF8A97A8)),
      TimerPhase.completed =>
        (const Color(0xFF1C1C4A), const Color(0xFF9D4EDD)),
      TimerPhase.idle => (_kBg, Colors.white),
    };

    final title = switch (controller.phase) {
      TimerPhase.prestart => 'Start in',
      TimerPhase.workout => 'Workout',
      TimerPhase.rest => 'Rest',
      TimerPhase.paused => 'Paused',
      TimerPhase.completed => 'Completed',
      TimerPhase.idle => 'Ready',
    };

    final centerValue = switch (controller.phase) {
      TimerPhase.workout => '${controller.workoutIntervalsRemaining}',
      TimerPhase.completed => 'Done',
      _ => '${controller.remainingSeconds}',
    };

    final subtitle = switch (controller.phase) {
      TimerPhase.prestart => 'Get ready',
      TimerPhase.workout =>
        'Set ${controller.currentSet}/${controller.sets} • intervals left',
      TimerPhase.rest => 'Until next period',
      TimerPhase.paused => 'Tap resume to continue',
      TimerPhase.completed => 'Great job!',
      TimerPhase.idle => '',
    };

    return Scaffold(
      body: GestureDetector(
        // Tap anywhere on the paused screen to resume
        onTap: controller.phase == TimerPhase.paused
            ? controller.startOrPause
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: backgroundColor,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                const SizedBox(height: 24),
                Text(title,
                    style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const Spacer(),
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: controller.phase == TimerPhase.completed
                              ? 1
                              : controller.phaseProgress,
                          strokeWidth: 16,
                          valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                          backgroundColor: Colors.white24,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(centerValue,
                              style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(
                              controller.phase == TimerPhase.workout
                                  ? 'intervals'
                                  : 'sec',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Set counter — shown prominently during workout & rest
                if (controller.phase == TimerPhase.workout ||
                    controller.phase == TimerPhase.rest) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Set ',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withValues(alpha: 0.45),
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${controller.currentSet}',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: ringColor),
                      ),
                      Text(
                        ' / ${controller.sets}',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.white70)),
                ],
                // Hint when paused
                if (controller.phase == TimerPhase.paused)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Tap anywhere to resume',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.35),
                          letterSpacing: 0.3),
                    ),
                  ),
                const Spacer(),
                if (controller.settings.showProgressBar) ...[
                  LinearProgressIndicator(
                    value: controller.progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total progress ${(controller.progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            if (controller.phase == TimerPhase.completed) {
                              controller.reset();
                            } else {
                              controller.startOrPause();
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: ringColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            controller.phase == TimerPhase.completed
                                ? 'NEW SESSION'
                                : controller.startButtonLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            controller.reset();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.white38, width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('RESET',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
