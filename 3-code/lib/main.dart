import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/settings/settings_repository.dart';
import 'features/statistics/workout_history_repository.dart';
import 'features/timer/timer_controller.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      title: 'Interval Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
