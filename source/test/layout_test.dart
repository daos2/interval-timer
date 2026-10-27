// Renders the screens that gained new controls at a small phone width, to
// catch RenderFlex overflow in the stepper rows and the chart strip.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:interval_timer/features/settings/app_settings.dart';
import 'package:interval_timer/features/settings/settings_repository.dart';
import 'package:interval_timer/features/settings/settings_screen.dart';
import 'package:interval_timer/features/info/donation.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import 'package:interval_timer/features/info/info_screen.dart';
import 'package:interval_timer/features/statistics/statistics_screen.dart';
import 'package:interval_timer/features/statistics/training_chart.dart';
import 'package:interval_timer/features/statistics/training_totals.dart';
import 'package:interval_timer/features/statistics/workout_history_repository.dart';
import 'package:interval_timer/features/statistics/workout_record.dart';
import 'package:interval_timer/features/timer/timer_controller.dart';
import 'package:interval_timer/features/timer/timer_screen.dart';

/// The Timer app bar carries a perpetually pulsing info badge, which would
/// make `pumpAndSettle` wait forever. Layout tests are about geometry, not
/// motion, so they run with animations switched off -- the same flag Android's
/// "Remove animations" setting sets. Pass `animations: true` to test the pulse
/// itself, and drive it with explicit `pump(duration)` calls.
Widget _host(TimerController c, Widget child, {bool animations = false}) =>
    ChangeNotifierProvider.value(
      value: c,
      child: MaterialApp(
        home: child,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: animations
            ? null
            : (context, inner) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(disableAnimations: true),
                  child: inner!,
                ),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  late TimerController controller;

  setUp(() {
    controller = TimerController(
      settingsRepository: SettingsRepository(),
      historyRepository: WorkoutHistoryRepository(),
      initialSettings: const AppSettings(),
      initialHistory: const [],
    );
  });

  testWidgets('timer setup screen fits a 360x640 phone', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(controller, const TimerScreen()));
    await tester.pump();

    // Frequency now shows two decimals and offers 0.01 s steps.
    expect(find.text('1.00'), findsOneWidget);
    expect(find.text('-0.01'), findsOneWidget);
    expect(find.text('+0.01'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('+/-0.01 buttons step frequency without drift', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(controller, const TimerScreen()));
    await tester.pump();

    for (var i = 0; i < 7; i++) {
      await tester.tap(find.text('-0.01'));
      await tester.pumpAndSettle();
    }
    expect(controller.frequencySeconds, closeTo(0.93, 1e-9));
    expect(find.text('0.93'), findsOneWidget);

    await tester.tap(find.text('+0.01'));
    await tester.pumpAndSettle();
    expect(controller.frequencySeconds, closeTo(0.94, 1e-9));
    expect(tester.takeException(), isNull);
  });

  testWidgets('timer setup screen survives a 320px-wide screen', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(controller, const TimerScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings screen shows the backup section and fits', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(controller, const SettingsScreen()));
    await tester.pump();

    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('Export backup'), 200,
        scrollable: list);
    await tester.pump();

    expect(find.text('BACKUP'), findsOneWidget);
    expect(find.text('Export backup'), findsOneWidget);
    expect(find.text('Import backup'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings screen prestart stepper fits and clamps',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(controller, const SettingsScreen()));
    await tester.pump();

    expect(find.text('PRESTART'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    // Two -5 taps land on 0, which renders as "Off / instant".
    await tester.tap(find.text('-5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('-5'));
    await tester.pumpAndSettle();
    expect(controller.settings.prestartSeconds, 0);
    expect(find.text('Off'), findsOneWidget);
    expect(find.text('instant'), findsOneWidget);

    // Already at the floor: further taps are inert, not negative.
    await tester.tap(find.text('-1'));
    await tester.pumpAndSettle();
    expect(controller.settings.prestartSeconds, 0);
    expect(tester.takeException(), isNull);
  });

  group('statistics chart', _chartTests);
  group('info screen', _infoTests);
}

// ── Statistics chart (v1.3) ───────────────────────────────────────────────

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

/// Dated relative to now, so the tests do not rot with the calendar.
List<WorkoutRecord> _recentHistory() {
  final now = DateTime.now();
  DateTime at(int daysAgo, int hour) =>
      DateTime(now.year, now.month, now.day - daysAgo, hour);
  return [
    _record(at(0, 7), 125),
    _record(at(1, 18), 300),
    _record(at(3, 6), 96, completed: false),
  ];
}

TimerController _withHistory(List<WorkoutRecord> history) => TimerController(
      settingsRepository: SettingsRepository(),
      historyRepository: WorkoutHistoryRepository(),
      initialSettings: const AppSettings(timerSignalEnabled: false),
      initialHistory: history,
    );

void _chartTests() {
  testWidgets('statistics chart fits 360px and agrees with the overview',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final controller = _withHistory(_recentHistory());
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, const StatisticsScreen()));
    await tester.pump();

    expect(find.text('TRAINING TIME'), findsOneWidget);
    expect(find.text('DAY'), findsOneWidget);
    expect(find.text('WEEK'), findsOneWidget);
    expect(find.text('MONTH'), findsOneWidget);

    final chart = find.byType(TrainingChartCard);
    // The chart counts every recorded session: 125 + 300 + 96 s.
    expect(find.descendant(of: chart, matching: find.text('8 min 41 sec')),
        findsOneWidget);
    // The Overview card above it counts completed sessions only (125 + 300),
    // so the two headline figures deliberately differ while the abandoned
    // 96 s session exists. See TimerController.totalTrainedSeconds.
    //
    // Only its absence from the chart is asserted, not a single match: the
    // current week's header shows the same 425 s whenever today and yesterday
    // fall in one week, which is every weekday except Monday.
    expect(find.text('7 min 5 sec'), findsWidgets);
    expect(find.descendant(of: chart, matching: find.text('7 min 5 sec')),
        findsNothing);
    expect(find.textContaining('tap a bar for detail'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('period buttons switch the bucket and fit a 320px screen',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final controller = _withHistory(_recentHistory());
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, const StatisticsScreen()));
    await tester.pump();
    expect(tester.takeException(), isNull);

    // Scoped to the card: 'This week' also appears in the week headers below.
    Finder caption(String word) => find.descendant(
        of: find.byType(TrainingChartCard),
        matching: find.textContaining(word));

    await tester.tap(find.text('MONTH'));
    await tester.pumpAndSettle();
    expect(caption('month'), findsOneWidget);

    await tester.tap(find.text('WEEK'));
    await tester.pumpAndSettle();
    expect(caption('week'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a bar names that period, tapping again clears it',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final controller = _withHistory(_recentHistory());
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, const StatisticsScreen()));
    await tester.pump();

    final today = find.byKey(ValueKey(bucketStartFor(DateTime.now(),
        ChartPeriod.day)));
    expect(today, findsOneWidget, reason: 'the chart opens pinned to today');

    await tester.tap(today);
    await tester.pumpAndSettle();
    expect(find.textContaining('tap a bar for detail'), findsNothing);
    expect(find.textContaining('1 session'), findsOneWidget);

    await tester.tap(today);
    await tester.pumpAndSettle();
    expect(find.textContaining('tap a bar for detail'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a long history scrolls instead of squeezing the bars',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final now = DateTime.now();
    final controller = _withHistory([
      for (var daysAgo = 0; daysAgo < 400; daysAgo += 2)
        _record(DateTime(now.year, now.month, now.day - daysAgo, 8),
            60 + daysAgo),
    ]);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, const StatisticsScreen()));
    await tester.pump();

    // 400 daily bars: the newest is on screen, the oldest is not built at all.
    final oldest = DateTime(now.year, now.month, now.day - 398);
    expect(find.byKey(ValueKey(bucketStartFor(now, ChartPeriod.day))),
        findsOneWidget);
    expect(find.byKey(ValueKey(oldest)), findsNothing);

    final strip = find.descendant(
        of: find.byType(TrainingChartCard), matching: find.byType(Scrollable));
    await tester.scrollUntilVisible(find.byKey(ValueKey(oldest)), 400,
        scrollable: strip);
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey(oldest)), findsOneWidget,
        reason: 'older bars are reachable by scrolling');
    expect(tester.takeException(), isNull);
  });
}


// ── Info / donations ───────────────────────────────────────────────

void _infoTests() {
  /// Captures Clipboard.setData, and swallows the haptics that share the
  /// same channel.
  List<String> captureClipboard(WidgetTester tester) {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));
    return copied;
  }

  /// The donation controls sit below the purpose card, and a ListView only
  /// builds what is on screen. Content assertions therefore use a viewport
  /// tall enough to lay the whole screen out at once; the narrow-screen test
  /// below scrolls instead, because that is the one measuring overflow.
  Future<TimerController> openInfo(
    WidgetTester tester, {
    Size size = const Size(400, 1600),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final controller = _withHistory(const []);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, const TimerScreen()));
    await tester.pump();
    await tester.tap(find.byType(InfoButton));
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets('the I badge sits in the app bar and opens the info screen',
      (tester) async {
    await openInfo(tester);

    // The badge sits beside the title, it does not replace it.
    expect(find.text('What this app is for'), findsOneWidget);
    expect(find.text('SUPPORT DEVELOPMENT'), findsOneWidget);
    expect(find.byType(InfoScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the badge renders in the timer app bar', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final controller = _withHistory(const []);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_host(controller, const TimerScreen()));
    await tester.pump();

    expect(find.text('Interval Timer'), findsOneWidget);
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('I')),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the pulse animates, and reduced motion lets the tree settle',
      (tester) async {
    final controller = _withHistory(const []);
    addTearDown(controller.dispose);

    // Animations on: the ring keeps scheduling frames, so pumpAndSettle would
    // time out -- stepping by hand is the only safe way to observe it.
    await tester.pumpWidget(
        _host(controller, const TimerScreen(), animations: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(InfoButton), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Reduced motion: no repeating ticker, so the tree reaches a steady state.
    await tester.pumpWidget(_host(controller, const TimerScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(InfoButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('each network shows its own address and QR', (tester) async {
    await openInfo(tester);

    // Opens on Bitcoin.
    expect(find.text(donationTargetFor(DonationNetwork.bitcoin).address),
        findsOneWidget);

    for (final target in kDonationTargets) {
      await tester.tap(find.text(target.tab));
      await tester.pumpAndSettle();

      expect(find.text(target.address), findsOneWidget,
          reason: '${target.name} address');
      expect(find.text('${target.name}  ·  ${target.chain}'),
          findsOneWidget, reason: '${target.name} caption');

      final qr = find.byWidgetPredicate((w) =>
          w is Image &&
          w.image is AssetImage &&
          (w.image as AssetImage).assetName == target.qrAsset);
      expect(qr, findsOneWidget, reason: '${target.name} QR asset');

      // The panel is 240 square minus 14 of padding each side. Asserted
      // because AnimatedSwitcher lays its children out loosely: without an
      // explicit expand the panel silently shrink-wraps the QR bitmap and
      // takes its pixel size instead of the square it is meant to fill.
      expect(tester.getSize(qr), const Size(212, 212),
          reason: '${target.name} QR box');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Copy puts the selected address on the clipboard',
      (tester) async {
    final copied = captureClipboard(tester);
    await openInfo(tester);

    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();
    expect(copied, [donationTargetFor(DonationNetwork.bitcoin).address]);
    expect(find.text('Bitcoin address copied'), findsOneWidget);

    // Switching network changes what Copy yields -- the bug worth guarding,
    // since BTC and ETH addresses are not interchangeable.
    await tester.tap(find.text('ETH'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();
    expect(copied.last, donationTargetFor(DonationNetwork.ethereum).address);
    expect(copied.last, isNot(copied.first));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the info screen scrolls without overflowing a 320px screen',
      (tester) async {
    await openInfo(tester, size: const Size(320, 640));

    // The purpose card fills the first screenful -- more so here than on a
    // device, since the test font draws every glyph as a full square -- so
    // the donation controls have to be scrolled to before they can be tapped.
    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('BTC'), 200, scrollable: list);
    await tester.pumpAndSettle();

    for (final target in kDonationTargets) {
      await tester.ensureVisible(find.text(target.tab));
      await tester.pumpAndSettle();
      await tester.tap(find.text(target.tab));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: target.name);
    }

    await tester.scrollUntilVisible(find.text('Copy'), 200, scrollable: list);
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
