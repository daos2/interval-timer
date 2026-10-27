// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionNewSession => 'NEW SESSION';

  @override
  String get actionPause => 'PAUSE';

  @override
  String get actionReplace => 'Replace';

  @override
  String get actionReset => 'RESET';

  @override
  String get actionResume => 'RESUME';

  @override
  String get actionStart => 'START';

  @override
  String addressCopied(String name) {
    return '$name address copied';
  }

  @override
  String backedUpOn(String date, String version) {
    return 'Backed up $date$version:';
  }

  @override
  String get backupContents => 'Backup contents:';

  @override
  String backupReadFailed(String error) {
    return 'Could not read that backup: $error';
  }

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restored $count workouts and your settings.',
      one: 'Restored 1 workout and your settings.',
    );
    return '$_temp0';
  }

  @override
  String backupSaveFailed(String error) {
    return 'Could not save the backup: $error';
  }

  @override
  String backupSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup saved — $count workouts and your settings.',
      one: 'Backup saved — 1 workout and your settings.',
    );
    return '$_temp0';
  }

  @override
  String get backupSub =>
      'Save settings and workout history to a .zip file, or restore them from one';

  @override
  String get bulletAllSettings => '• All app settings';

  @override
  String bulletWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '• $count workouts',
      one: '• 1 workout',
    );
    return '$_temp0';
  }

  @override
  String get chainBitcoin => 'Bitcoin network';

  @override
  String get completedLabel => 'Completed';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get dialogChooseBackup => 'Choose an Interval Timer backup';

  @override
  String get dialogSaveBackup => 'Save Interval Timer backup';

  @override
  String get done1 => 'Classic fanfare';

  @override
  String get done2 => 'Rising fanfare';

  @override
  String get done3 => 'Bright finale';

  @override
  String get doneFanfareSub =>
      'Plays at the end of all periods — choose one of 3 fanfares';

  @override
  String durCompactHour(String n) {
    return '$n h';
  }

  @override
  String durCompactMin(int n) {
    return '$n m';
  }

  @override
  String durCompactSec(int n) {
    return '$n s';
  }

  @override
  String durHour(int n) {
    return '$n h';
  }

  @override
  String durMin(int n) {
    return '$n min';
  }

  @override
  String get durNone => '—';

  @override
  String durSec(int n) {
    return '$n sec';
  }

  @override
  String get exportBackup => 'Export backup';

  @override
  String get exportCancelled => 'Export cancelled.';

  @override
  String exportSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'your settings and $count workouts to a .zip file',
      one: 'your settings and 1 workout to a .zip file',
    );
    return 'Save $_temp0';
  }

  @override
  String get exportSubtitleEmpty => 'Save your settings to a .zip file';

  @override
  String get importBackup => 'Import backup';

  @override
  String get importBackupSub => 'Replace settings and history from a .zip file';

  @override
  String get importCancelled => 'Import cancelled.';

  @override
  String get infoBadgeSemantics => 'About and support';

  @override
  String get infoTitle => 'About & Support';

  @override
  String get keepScreenOn => 'Keep screen on';

  @override
  String get keepScreenOnSub => 'Prevent display sleep while timer is running';

  @override
  String get labelFrequency => 'FREQUENCY';

  @override
  String get labelRestInterval => 'REST INTERVAL';

  @override
  String get labelSets => 'SETS';

  @override
  String get labelWorkoutInterval => 'WORKOUT INTERVAL';

  @override
  String get languageSub =>
      'Choose the app language, or follow the system setting';

  @override
  String get languageSystem => 'System default';

  @override
  String get lastWeek => 'Last week';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String get navSettings => 'Settings';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get navTimer => 'Timer';

  @override
  String get networkWarning =>
      'Send only on the selected network. Ethereum and BNB Chain share one address, so the network you send on is what decides where the funds land.';

  @override
  String get noTraining => 'no training';

  @override
  String get noWorkoutsYet => 'No workouts yet';

  @override
  String get overview => 'OVERVIEW';

  @override
  String get periodDay => 'DAY';

  @override
  String get periodMonth => 'MONTH';

  @override
  String get periodWeek => 'WEEK';

  @override
  String get prestartInstant => 'instant';

  @override
  String get prestartOff => 'Off';

  @override
  String get prestartSub =>
      'Countdown before the first interval — set 0 to start instantly';

  @override
  String get progressBar => 'Progress bar';

  @override
  String get progressBarSub => 'Show or hide total completion progress';

  @override
  String get purposeBullet1 =>
      'Set the work interval, rest, sets and tick frequency, then start. Audio cues mark every tick and every change of phase, so the phone can stay in your pocket.';

  @override
  String get purposeBullet2 =>
      'The screen stays awake while a session runs, and a countdown gives you time to get into position.';

  @override
  String get purposeBullet3 =>
      'Finished sessions are recorded. Statistics shows your totals, streaks and a bar chart of training time by day, week or month.';

  @override
  String get purposeBullet4 =>
      'Everything is stored on your device. Settings and history can be exported to a backup file and restored later.';

  @override
  String get purposeIntro =>
      'Interval Timer runs work-and-rest workouts — HIIT, circuits, stretching, breathing drills — so you can keep your eyes off the screen and your hands free.';

  @override
  String qrSemantics(String name) {
    return '$name donation QR code';
  }

  @override
  String recordDetail(int units, int rest, int sets, String freq) {
    return 'Units $units  ·  Rest ${rest}s  ·  Sets $sets  ·  Freq ${freq}s';
  }

  @override
  String replaceWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This replaces your current settings and $count saved workouts. That cannot be undone.',
      one:
          'This replaces your current settings and 1 saved workout. That cannot be undone.',
    );
    return '$_temp0';
  }

  @override
  String get replaceWarningEmpty =>
      'This replaces your current settings. You have no saved workouts to lose.';

  @override
  String get restoreDialogTitle => 'Restore this backup?';

  @override
  String get sectionBackup => 'BACKUP';

  @override
  String get sectionDoneFanfare => 'DONE FANFARE';

  @override
  String get sectionGeneral => 'GENERAL';

  @override
  String get sectionLanguage => 'LANGUAGE';

  @override
  String get sectionPrestart => 'PRESTART';

  @override
  String get sectionTickSound => 'TICK SOUND';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get setWord => 'Set';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusRest => 'Rest';

  @override
  String get statusStartIn => 'Start in';

  @override
  String get statusWorkout => 'Workout';

  @override
  String get subGetReady => 'Get ready';

  @override
  String get subGreatJob => 'Great job!';

  @override
  String subSetProgress(int current, int total) {
    return 'Set $current/$total • intervals left';
  }

  @override
  String get subTapResume => 'Tap resume to continue';

  @override
  String get subUntilNext => 'Until next period';

  @override
  String get supportDevelopment => 'SUPPORT DEVELOPMENT';

  @override
  String get supportIntro =>
      'The app is free, has no ads and collects nothing. If it is useful to you, a tip is welcome — pick a network and scan or copy the address.';

  @override
  String get tapAnywhereToResume => 'Tap anywhere to resume';

  @override
  String get tapBarForDetail => 'tap a bar for detail';

  @override
  String get thisWeek => 'This week';

  @override
  String get tick1 => 'Soft click';

  @override
  String get tick2 => 'Double click';

  @override
  String get tick3 => 'Alert click';

  @override
  String get tick4 => 'Punchy click';

  @override
  String get tick5 => 'Triple click';

  @override
  String get tick6 => 'Bright click';

  @override
  String get tickSoundSub =>
      'Plays at every workout unit — choose one of 6 short clicks';

  @override
  String get timerSignal => 'Timer signal';

  @override
  String get timerSignalSub => 'Play signal at every workout unit';

  @override
  String totalProgress(String percent) {
    return 'Total progress $percent%';
  }

  @override
  String totalSuffix(int seconds) {
    return '$seconds sec total';
  }

  @override
  String get trainingTime => 'TRAINING TIME';

  @override
  String get unitIntervals => 'intervals';

  @override
  String get unitSec => 'sec';

  @override
  String get unitUnits => 'units';

  @override
  String get valueDone => 'Done';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
    );
    return '$_temp0';
  }

  @override
  String get whatThisAppIsFor => 'What this app is for';
}
