import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

import '../features/settings/settings_screen.dart';
import '../features/statistics/statistics_screen.dart';
import '../features/timer/timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const TimerScreen(),
      const SettingsScreen(),
      const StatisticsScreen(),
    ];

    final l = AppLocalizations.of(context);

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: const Icon(Icons.timer),
            label: l.navTimer,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l.navSettings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l.navStatistics,
          ),
        ],
      ),
    );
  }
}
