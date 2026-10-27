// The language picker, and the guarantees that keep it honest.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:interval_timer/features/settings/app_settings.dart';
import 'package:interval_timer/features/settings/settings_repository.dart';
import 'package:interval_timer/features/settings/settings_screen.dart';
import 'package:interval_timer/features/statistics/workout_history_repository.dart';
import 'package:interval_timer/features/timer/timer_controller.dart';
import 'package:interval_timer/features/timer/timer_screen.dart';
import 'package:interval_timer/l10n/app_localizations.dart';

TimerController _controller({String language = ''}) => TimerController(
      settingsRepository: SettingsRepository(),
      historyRepository: WorkoutHistoryRepository(),
      initialSettings:
          AppSettings(timerSignalEnabled: false, languageCode: language),
      initialHistory: const [],
    );

/// Mirrors main.dart: the chosen code drives MaterialApp.locale.
Widget _app(TimerController c, Widget home) => ChangeNotifierProvider.value(
      value: c,
      child: Consumer<TimerController>(
        builder: (context, controller, _) {
          final code = controller.settings.languageCode;
          return MaterialApp(
            home: home,
            locale: code.isEmpty ? null : Locale(code),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, inner) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: inner!,
            ),
          );
        },
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  group('translation files', () {
    final dir = Directory('lib/l10n');
    final template = json.decode(
        File('lib/l10n/app_en.arb').readAsStringSync()) as Map<String, dynamic>;
    final keys = template.keys.where((k) => !k.startsWith('@')).toSet();

    test('every supported language has an .arb file', () {
      for (final code in AppSettings.supportedLanguageCodes) {
        expect(File('lib/l10n/app_$code.arb').existsSync(), isTrue,
            reason: 'missing app_$code.arb');
      }
    });

    test('no language is missing a key, and none has a stray one', () {
      // A missing key does not fail the build -- it silently falls back to
      // English, which is exactly the kind of half-translated screen this
      // suite exists to prevent.
      for (final file in dir.listSync().whereType<File>()) {
        if (!file.path.endsWith('.arb')) continue;
        final doc =
            json.decode(file.readAsStringSync()) as Map<String, dynamic>;
        final theirs =
            doc.keys.where((k) => !k.startsWith('@')).toSet();
        expect(theirs.difference(keys), isEmpty,
            reason: '${file.path} has keys English does not');
        expect(keys.difference(theirs), isEmpty,
            reason: '${file.path} is missing keys');
      }
    });

    test('no locale file was generated and left untranslated', () {
      // A ratio, not a per-key check: some words really are identical across
      // languages -- German for "Timer" is "Timer", and "Pause" is shared by
      // three of these -- so a single matching string proves nothing. A file
      // that is still wholesale English is what this needs to catch.
      for (final code in ['de', 'fr', 'es', 'ru', 'ka']) {
        final doc = json.decode(File('lib/l10n/app_$code.arb')
            .readAsStringSync()) as Map<String, dynamic>;
        final differing =
            keys.where((k) => doc[k] != template[k]).length;
        expect(differing / keys.length, greaterThan(0.85),
            reason: '$code looks largely untranslated');
      }
    });
  });

  group('language picker', () {
    testWidgets('defaults to following the system', (tester) async {
      final c = _controller();
      addTearDown(c.dispose);
      expect(c.settings.languageCode, '');
    });

    testWidgets('choosing a language retranslates the UI', (tester) async {
      tester.view.physicalSize = const Size(420, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final c = _controller();
      addTearDown(c.dispose);

      await tester.pumpWidget(_app(c, const SettingsScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      // Languages are listed as endonyms, so this row says the same thing
      // whatever language the UI is currently in.
      await tester.tap(find.text('Deutsch'));
      await tester.pumpAndSettle();

      expect(c.settings.languageCode, 'de');
      expect(find.text('Einstellungen'), findsOneWidget);
      expect(find.text('Settings'), findsNothing);

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();
      expect(find.text('Настройки'), findsOneWidget);

      await tester.tap(find.text('ქართული'));
      await tester.pumpAndSettle();
      expect(find.text('პარამეტრები'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the choice reaches the timer screen too', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Seeded through the constructor, not updateSettings: awaiting that
      // before the tree is pumped hangs, because it waits on platform-channel
      // work that only completes once the binding starts pumping frames.
      final c = _controller(language: 'fr');
      addTearDown(c.dispose);

      await tester.pumpWidget(_app(c, const TimerScreen()));
      await tester.pumpAndSettle();

      expect(find.text('INTERVALLE D’EFFORT'), findsOneWidget);
      expect(find.text('WORKOUT INTERVAL'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('an unsupported code falls back to the system locale',
        (tester) async {
      // Reached by a backup from a future build, or a hand-edited file.
      // Like prestartSeconds, the clamp lives in fromJson and copyWith --
      // the default constructor is const and cannot run one.
      final restored = AppSettings.fromJson(
          const <String, Object?>{'languageCode': 'tlh'});
      expect(restored.languageCode, '');

      expect(const AppSettings().copyWith(languageCode: 'klingon')
          .languageCode, '');
      expect(const AppSettings(languageCode: 'ka')
          .copyWith(languageCode: 'nope').languageCode, '');
    });

    testWidgets('the language survives a settings round trip', (tester) async {
      const settings = AppSettings(languageCode: 'ka');
      final restored = AppSettings.fromJson(settings.toJson());
      expect(restored.languageCode, 'ka');
    });
  });

  group('app bar version', () {
    testWidgets('shows the version under the title', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final c = _controller();
      addTearDown(c.dispose);

      await tester.pumpWidget(_app(c, const TimerScreen()));
      await tester.pumpAndSettle();

      final version = find.textContaining(RegExp(r'^v\d+\.\d+\.\d+$'));
      expect(version, findsOneWidget);
      expect(
          find.ancestor(of: version, matching: find.byType(AppBar)),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
