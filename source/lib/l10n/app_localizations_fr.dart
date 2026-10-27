// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionCopy => 'Copier';

  @override
  String get actionNewSession => 'NOUVELLE SÉANCE';

  @override
  String get actionPause => 'PAUSE';

  @override
  String get actionReplace => 'Remplacer';

  @override
  String get actionReset => 'RÉINITIALISER';

  @override
  String get actionResume => 'REPRENDRE';

  @override
  String get actionStart => 'DÉMARRER';

  @override
  String addressCopied(String name) {
    return 'Adresse $name copiée';
  }

  @override
  String backedUpOn(String date, String version) {
    return 'Sauvegardé le $date$version :';
  }

  @override
  String get backupContents => 'Contenu de la sauvegarde :';

  @override
  String backupReadFailed(String error) {
    return 'Impossible de lire cette sauvegarde : $error';
  }

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séances et vos réglages restaurés.',
      one: '1 séance et vos réglages restaurés.',
    );
    return '$_temp0';
  }

  @override
  String backupSaveFailed(String error) {
    return 'Impossible d’enregistrer la sauvegarde : $error';
  }

  @override
  String backupSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sauvegarde enregistrée — $count séances et vos réglages.',
      one: 'Sauvegarde enregistrée — 1 séance et vos réglages.',
    );
    return '$_temp0';
  }

  @override
  String get backupSub =>
      'Enregistrez les réglages et l’historique dans un fichier .zip, ou restaurez-les';

  @override
  String get bulletAllSettings => '• Tous les réglages';

  @override
  String bulletWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '• $count séances',
      one: '• 1 séance',
    );
    return '$_temp0';
  }

  @override
  String get chainBitcoin => 'Réseau Bitcoin';

  @override
  String get completedLabel => 'Terminées';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get dialogChooseBackup => 'Choisir une sauvegarde Interval Timer';

  @override
  String get dialogSaveBackup => 'Enregistrer la sauvegarde Interval Timer';

  @override
  String get done1 => 'Fanfare classique';

  @override
  String get done2 => 'Fanfare ascendante';

  @override
  String get done3 => 'Final éclatant';

  @override
  String get doneFanfareSub =>
      'Retentit à la fin de toutes les périodes — choisissez parmi 3 fanfares';

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
    return '$n s';
  }

  @override
  String get exportBackup => 'Exporter la sauvegarde';

  @override
  String get exportCancelled => 'Exportation annulée.';

  @override
  String exportSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vos réglages et $count séances dans un .zip',
      one: 'vos réglages et 1 séance dans un .zip',
    );
    return 'Save $_temp0';
  }

  @override
  String get exportSubtitleEmpty => 'Enregistrer vos réglages dans un .zip';

  @override
  String get importBackup => 'Importer une sauvegarde';

  @override
  String get importBackupSub =>
      'Remplacer les réglages et l’historique depuis un .zip';

  @override
  String get importCancelled => 'Importation annulée.';

  @override
  String get infoBadgeSemantics => 'À propos et soutien';

  @override
  String get infoTitle => 'À propos et soutien';

  @override
  String get keepScreenOn => 'Garder l’écran allumé';

  @override
  String get keepScreenOnSub =>
      'Empêche la mise en veille pendant la minuterie';

  @override
  String get labelFrequency => 'FRÉQUENCE';

  @override
  String get labelRestInterval => 'INTERVALLE DE REPOS';

  @override
  String get labelSets => 'SÉRIES';

  @override
  String get labelWorkoutInterval => 'INTERVALLE D’EFFORT';

  @override
  String get languageSub =>
      'Choisissez la langue de l’app, ou suivez le système';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get lastWeek => 'La semaine dernière';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: '1 mois',
    );
    return '$_temp0';
  }

  @override
  String get navSettings => 'Réglages';

  @override
  String get navStatistics => 'Statistiques';

  @override
  String get navTimer => 'Minuteur';

  @override
  String get networkWarning =>
      'N’envoyez que sur le réseau sélectionné. Ethereum et BNB Chain partagent une adresse : c’est le réseau qui détermine la destination des fonds.';

  @override
  String get noTraining => 'aucun entraînement';

  @override
  String get noWorkoutsYet => 'Aucune séance pour l’instant';

  @override
  String get overview => 'APERÇU';

  @override
  String get periodDay => 'JOUR';

  @override
  String get periodMonth => 'MOIS';

  @override
  String get periodWeek => 'SEMAINE';

  @override
  String get prestartInstant => 'immédiat';

  @override
  String get prestartOff => 'Désactivé';

  @override
  String get prestartSub =>
      'Décompte avant le premier intervalle — 0 pour démarrer immédiatement';

  @override
  String get progressBar => 'Barre de progression';

  @override
  String get progressBarSub => 'Afficher ou masquer la progression totale';

  @override
  String get purposeBullet1 =>
      'Réglez l’effort, le repos, les séries et la fréquence, puis démarrez. Des signaux marquent chaque tic et chaque changement de phase : le téléphone reste dans la poche.';

  @override
  String get purposeBullet2 =>
      'L’écran reste allumé pendant la séance, et un décompte vous laisse le temps de vous placer.';

  @override
  String get purposeBullet3 =>
      'Les séances terminées sont enregistrées. Les statistiques montrent totaux, séries et un graphique par jour, semaine ou mois.';

  @override
  String get purposeBullet4 =>
      'Tout est stocké sur votre appareil. Réglages et historique peuvent être sauvegardés puis restaurés.';

  @override
  String get purposeIntro =>
      'Interval Timer gère les séances effort-repos — HIIT, circuits, étirements, respiration — pour garder les yeux loin de l’écran et les mains libres.';

  @override
  String qrSemantics(String name) {
    return 'QR code de don $name';
  }

  @override
  String recordDetail(int units, int rest, int sets, String freq) {
    return 'Unités $units  ·  Repos ${rest}s  ·  Séries $sets  ·  Fréq. ${freq}s';
  }

  @override
  String replaceWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Cela remplace vos réglages et $count séances enregistrées. Action irréversible.',
      one:
          'Cela remplace vos réglages et 1 séance enregistrée. Action irréversible.',
    );
    return '$_temp0';
  }

  @override
  String get replaceWarningEmpty =>
      'Cela remplace vos réglages actuels. Vous n’avez aucune séance à perdre.';

  @override
  String get restoreDialogTitle => 'Restaurer cette sauvegarde ?';

  @override
  String get sectionBackup => 'SAUVEGARDE';

  @override
  String get sectionDoneFanfare => 'FANFARE FINALE';

  @override
  String get sectionGeneral => 'GÉNÉRAL';

  @override
  String get sectionLanguage => 'LANGUE';

  @override
  String get sectionPrestart => 'DÉCOMPTE';

  @override
  String get sectionTickSound => 'SON DE TIC';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séances',
      one: '1 séance',
    );
    return '$_temp0';
  }

  @override
  String get setWord => 'Série';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusPaused => 'En pause';

  @override
  String get statusReady => 'Prêt';

  @override
  String get statusRest => 'Repos';

  @override
  String get statusStartIn => 'Début dans';

  @override
  String get statusWorkout => 'Effort';

  @override
  String get subGetReady => 'Préparez-vous';

  @override
  String get subGreatJob => 'Bravo !';

  @override
  String subSetProgress(int current, int total) {
    return 'Série $current/$total • intervalles restants';
  }

  @override
  String get subTapResume => 'Appuyez sur Reprendre pour continuer';

  @override
  String get subUntilNext => 'Jusqu’à la prochaine période';

  @override
  String get supportDevelopment => 'SOUTENIR LE DÉVELOPPEMENT';

  @override
  String get supportIntro =>
      'L’app est gratuite, sans publicité et ne collecte rien. Si elle vous est utile, un don est bienvenu — choisissez un réseau, scannez ou copiez l’adresse.';

  @override
  String get tapAnywhereToResume => 'Touchez l’écran pour reprendre';

  @override
  String get tapBarForDetail => 'touchez une barre pour le détail';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get tick1 => 'Clic doux';

  @override
  String get tick2 => 'Double clic';

  @override
  String get tick3 => 'Clic d’alerte';

  @override
  String get tick4 => 'Clic percutant';

  @override
  String get tick5 => 'Triple clic';

  @override
  String get tick6 => 'Clic clair';

  @override
  String get tickSoundSub =>
      'Retentit à chaque unité d’effort — choisissez parmi 6 clics courts';

  @override
  String get timerSignal => 'Signal sonore';

  @override
  String get timerSignalSub => 'Émet un signal à chaque unité d’effort';

  @override
  String totalProgress(String percent) {
    return 'Progression totale $percent%';
  }

  @override
  String totalSuffix(int seconds) {
    return '$seconds s au total';
  }

  @override
  String get trainingTime => 'TEMPS D’ENTRAÎNEMENT';

  @override
  String get unitIntervals => 'intervalles';

  @override
  String get unitSec => 's';

  @override
  String get unitUnits => 'unités';

  @override
  String get valueDone => 'Fini';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semaines',
      one: '1 semaine',
    );
    return '$_temp0';
  }

  @override
  String get whatThisAppIsFor => 'À quoi sert cette app';
}
