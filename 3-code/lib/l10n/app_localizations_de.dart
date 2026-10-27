// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionCopy => 'Kopieren';

  @override
  String get actionNewSession => 'NEUE EINHEIT';

  @override
  String get actionPause => 'PAUSE';

  @override
  String get actionReplace => 'Ersetzen';

  @override
  String get actionReset => 'ZURÜCKSETZEN';

  @override
  String get actionResume => 'WEITER';

  @override
  String get actionStart => 'START';

  @override
  String addressCopied(String name) {
    return '$name-Adresse kopiert';
  }

  @override
  String backedUpOn(String date, String version) {
    return 'Gesichert am $date$version:';
  }

  @override
  String get backupContents => 'Inhalt der Sicherung:';

  @override
  String backupReadFailed(String error) {
    return 'Sicherung konnte nicht gelesen werden: $error';
  }

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Trainings und deine Einstellungen wiederhergestellt.',
      one: '1 Training und deine Einstellungen wiederhergestellt.',
    );
    return '$_temp0';
  }

  @override
  String backupSaveFailed(String error) {
    return 'Sicherung konnte nicht gespeichert werden: $error';
  }

  @override
  String backupSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Sicherung gespeichert — $count Trainings und deine Einstellungen.',
      one: 'Sicherung gespeichert — 1 Training und deine Einstellungen.',
    );
    return '$_temp0';
  }

  @override
  String get backupSub =>
      'Einstellungen und Trainingsverlauf in eine .zip-Datei sichern oder daraus wiederherstellen';

  @override
  String get bulletAllSettings => '• Alle App-Einstellungen';

  @override
  String bulletWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '• $count Trainings',
      one: '• 1 Training',
    );
    return '$_temp0';
  }

  @override
  String get chainBitcoin => 'Bitcoin-Netzwerk';

  @override
  String get completedLabel => 'Abgeschlossen';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get dialogChooseBackup => 'Interval Timer-Sicherung auswählen';

  @override
  String get dialogSaveBackup => 'Interval Timer-Sicherung speichern';

  @override
  String get done1 => 'Klassische Fanfare';

  @override
  String get done2 => 'Aufsteigende Fanfare';

  @override
  String get done3 => 'Helles Finale';

  @override
  String get doneFanfareSub =>
      'Ertönt am Ende aller Runden — wähle eine von 3 Fanfaren';

  @override
  String durCompactHour(String n) {
    return '$n Std.';
  }

  @override
  String durCompactMin(int n) {
    return '$n Min.';
  }

  @override
  String durCompactSec(int n) {
    return '$n s';
  }

  @override
  String durHour(int n) {
    return '$n Std.';
  }

  @override
  String durMin(int n) {
    return '$n Min.';
  }

  @override
  String get durNone => '—';

  @override
  String durSec(int n) {
    return '$n Sek.';
  }

  @override
  String get exportBackup => 'Sicherung exportieren';

  @override
  String get exportCancelled => 'Export abgebrochen.';

  @override
  String exportSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Einstellungen und $count Trainings in eine .zip-Datei',
      one: 'Einstellungen und 1 Training in eine .zip-Datei',
    );
    return 'Save $_temp0';
  }

  @override
  String get exportSubtitleEmpty => 'Einstellungen in eine .zip-Datei sichern';

  @override
  String get importBackup => 'Sicherung importieren';

  @override
  String get importBackupSub =>
      'Einstellungen und Verlauf aus einer .zip-Datei ersetzen';

  @override
  String get importCancelled => 'Import abgebrochen.';

  @override
  String get infoBadgeSemantics => 'Über und unterstützen';

  @override
  String get infoTitle => 'Über & Unterstützen';

  @override
  String get keepScreenOn => 'Bildschirm anlassen';

  @override
  String get keepScreenOnSub =>
      'Verhindert, dass der Bildschirm während des Timers ausgeht';

  @override
  String get labelFrequency => 'FREQUENZ';

  @override
  String get labelRestInterval => 'PAUSENINTERVALL';

  @override
  String get labelSets => 'SÄTZE';

  @override
  String get labelWorkoutInterval => 'TRAININGSINTERVALL';

  @override
  String get languageSub =>
      'App-Sprache wählen oder der Systemeinstellung folgen';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get lastWeek => 'Letzte Woche';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monate',
      one: '1 Monat',
    );
    return '$_temp0';
  }

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navStatistics => 'Statistik';

  @override
  String get navTimer => 'Timer';

  @override
  String get networkWarning =>
      'Sende nur im gewählten Netzwerk. Ethereum und BNB Chain teilen sich eine Adresse — das gewählte Netzwerk entscheidet, wo die Mittel ankommen.';

  @override
  String get noTraining => 'kein Training';

  @override
  String get noWorkoutsYet => 'Noch keine Trainings';

  @override
  String get overview => 'ÜBERSICHT';

  @override
  String get periodDay => 'TAG';

  @override
  String get periodMonth => 'MONAT';

  @override
  String get periodWeek => 'WOCHE';

  @override
  String get prestartInstant => 'sofort';

  @override
  String get prestartOff => 'Aus';

  @override
  String get prestartSub =>
      'Countdown vor dem ersten Intervall — 0 startet sofort';

  @override
  String get progressBar => 'Fortschrittsbalken';

  @override
  String get progressBarSub => 'Gesamtfortschritt ein- oder ausblenden';

  @override
  String get purposeBullet1 =>
      'Stelle Belastung, Pause, Sätze und Tick-Frequenz ein und starte. Tonsignale markieren jeden Tick und jeden Phasenwechsel — das Handy kann in der Tasche bleiben.';

  @override
  String get purposeBullet2 =>
      'Der Bildschirm bleibt während einer Einheit an, und ein Countdown gibt dir Zeit, dich bereitzumachen.';

  @override
  String get purposeBullet3 =>
      'Abgeschlossene Einheiten werden erfasst. Die Statistik zeigt Summen, Serien und ein Balkendiagramm nach Tag, Woche oder Monat.';

  @override
  String get purposeBullet4 =>
      'Alles wird auf deinem Gerät gespeichert. Einstellungen und Verlauf lassen sich sichern und später wiederherstellen.';

  @override
  String get purposeIntro =>
      'Interval Timer steuert Trainings mit Belastung und Pause — HIIT, Zirkel, Dehnen, Atemübungen — damit du den Blick vom Bildschirm und die Hände frei hast.';

  @override
  String qrSemantics(String name) {
    return '$name-Spenden-QR-Code';
  }

  @override
  String recordDetail(int units, int rest, int sets, String freq) {
    return 'Einheiten $units  ·  Pause ${rest}s  ·  Sätze $sets  ·  Freq. ${freq}s';
  }

  @override
  String replaceWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dies ersetzt deine Einstellungen und $count gespeicherte Trainings. Das kann nicht rückgängig gemacht werden.',
      one:
          'Dies ersetzt deine Einstellungen und 1 gespeichertes Training. Das kann nicht rückgängig gemacht werden.',
    );
    return '$_temp0';
  }

  @override
  String get replaceWarningEmpty =>
      'Dies ersetzt deine aktuellen Einstellungen. Du hast keine gespeicherten Trainings zu verlieren.';

  @override
  String get restoreDialogTitle => 'Diese Sicherung wiederherstellen?';

  @override
  String get sectionBackup => 'SICHERUNG';

  @override
  String get sectionDoneFanfare => 'SCHLUSSFANFARE';

  @override
  String get sectionGeneral => 'ALLGEMEIN';

  @override
  String get sectionLanguage => 'SPRACHE';

  @override
  String get sectionPrestart => 'VORLAUF';

  @override
  String get sectionTickSound => 'TICK-TON';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einheiten',
      one: '1 Einheit',
    );
    return '$_temp0';
  }

  @override
  String get setWord => 'Satz';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get statisticsTitle => 'Statistik';

  @override
  String get statusCompleted => 'Fertig';

  @override
  String get statusPaused => 'Pausiert';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusRest => 'Pause';

  @override
  String get statusStartIn => 'Start in';

  @override
  String get statusWorkout => 'Training';

  @override
  String get subGetReady => 'Mach dich bereit';

  @override
  String get subGreatJob => 'Gut gemacht!';

  @override
  String subSetProgress(int current, int total) {
    return 'Satz $current/$total • Intervalle übrig';
  }

  @override
  String get subTapResume => 'Zum Fortfahren auf Weiter tippen';

  @override
  String get subUntilNext => 'Bis zur nächsten Runde';

  @override
  String get supportDevelopment => 'ENTWICKLUNG UNTERSTÜTZEN';

  @override
  String get supportIntro =>
      'Die App ist kostenlos, werbefrei und sammelt nichts. Wenn sie dir nützt, freue ich mich über eine Spende — Netzwerk wählen, scannen oder Adresse kopieren.';

  @override
  String get tapAnywhereToResume => 'Zum Fortsetzen irgendwo tippen';

  @override
  String get tapBarForDetail => 'Balken für Details antippen';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get tick1 => 'Weicher Klick';

  @override
  String get tick2 => 'Doppelklick';

  @override
  String get tick3 => 'Signalklick';

  @override
  String get tick4 => 'Kräftiger Klick';

  @override
  String get tick5 => 'Dreifachklick';

  @override
  String get tick6 => 'Heller Klick';

  @override
  String get tickSoundSub =>
      'Ertönt bei jeder Trainingseinheit — wähle einen von 6 kurzen Klicks';

  @override
  String get timerSignal => 'Tonsignal';

  @override
  String get timerSignalSub => 'Signal bei jeder Trainingseinheit abspielen';

  @override
  String totalProgress(String percent) {
    return 'Gesamtfortschritt $percent%';
  }

  @override
  String totalSuffix(int seconds) {
    return '$seconds Sek. gesamt';
  }

  @override
  String get trainingTime => 'TRAININGSZEIT';

  @override
  String get unitIntervals => 'Intervalle';

  @override
  String get unitSec => 'Sek.';

  @override
  String get unitUnits => 'Einheiten';

  @override
  String get valueDone => 'Fertig';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wochen',
      one: '1 Woche',
    );
    return '$_temp0';
  }

  @override
  String get whatThisAppIsFor => 'Wofür diese App da ist';
}
