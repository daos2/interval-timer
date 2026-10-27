import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';

import 'features/settings/settings_repository.dart';
import 'features/statistics/workout_history_repository.dart';
import 'features/timer/timer_controller.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Month and weekday names for every locale the app offers; without this
  // DateFormat throws for anything but en_US.
  await initializeDateFormatting();
  final settingsRepository = SettingsRepository();
  final historyRepository = WorkoutHistoryRepository();

  final settings = await settingsRepository.load();
  final history = await historyRepository.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<SettingsRepository>.value(value: settingsRepository),
        Provider<WorkoutHistoryRepository>.value(value: historyRepository),
        ChangeNotifierProvider<TimerController>(
          create: (context) => TimerController(
            settingsRepository: settingsRepository,
            historyRepository: historyRepository,
            initialSettings: settings,
            initialHistory: history,
          ),
        ),
      ],
      child: const IntervalTimerApp(),
    ),
  );
}

class IntervalTimerApp extends StatelessWidget {
  const IntervalTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.watch<TimerController>().settings.languageCode;
    final locale = code.isEmpty ? null : Locale(code);

    return MaterialApp(
      title: 'Interval Timer',
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Keeps bare DateFormat(...) calls in sync with the chosen language.
      localeResolutionCallback: (deviceLocale, supported) {
        final resolved = locale ??
            supported.firstWhere(
              (l) => l.languageCode == deviceLocale?.languageCode,
              orElse: () => const Locale('en'),
            );
        Intl.defaultLocale = resolved.languageCode;
        return resolved;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
