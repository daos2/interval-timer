import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ka'),
    Locale('ru')
  ];

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionNewSession.
  ///
  /// In en, this message translates to:
  /// **'NEW SESSION'**
  String get actionNewSession;

  /// No description provided for @actionPause.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get actionPause;

  /// No description provided for @actionReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get actionReplace;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get actionReset;

  /// No description provided for @actionResume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get actionResume;

  /// No description provided for @actionStart.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get actionStart;

  /// No description provided for @addressCopied.
  ///
  /// In en, this message translates to:
  /// **'{name} address copied'**
  String addressCopied(String name);

  /// No description provided for @backedUpOn.
  ///
  /// In en, this message translates to:
  /// **'Backed up {date}{version}:'**
  String backedUpOn(String date, String version);

  /// No description provided for @backupContents.
  ///
  /// In en, this message translates to:
  /// **'Backup contents:'**
  String get backupContents;

  /// No description provided for @backupReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read that backup: {error}'**
  String backupReadFailed(String error);

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Restored 1 workout and your settings.} other{Restored {count} workouts and your settings.}}'**
  String backupRestored(int count);

  /// No description provided for @backupSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the backup: {error}'**
  String backupSaveFailed(String error);

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Backup saved — 1 workout and your settings.} other{Backup saved — {count} workouts and your settings.}}'**
  String backupSaved(int count);

  /// No description provided for @backupSub.
  ///
  /// In en, this message translates to:
  /// **'Save settings and workout history to a .zip file, or restore them from one'**
  String get backupSub;

  /// No description provided for @bulletAllSettings.
  ///
  /// In en, this message translates to:
  /// **'• All app settings'**
  String get bulletAllSettings;

  /// No description provided for @bulletWorkouts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{• 1 workout} other{• {count} workouts}}'**
  String bulletWorkouts(int count);

  /// No description provided for @chainBitcoin.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin network'**
  String get chainBitcoin;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String daysCount(int count);

  /// No description provided for @dialogChooseBackup.
  ///
  /// In en, this message translates to:
  /// **'Choose an Interval Timer backup'**
  String get dialogChooseBackup;

  /// No description provided for @dialogSaveBackup.
  ///
  /// In en, this message translates to:
  /// **'Save Interval Timer backup'**
  String get dialogSaveBackup;

  /// No description provided for @done1.
  ///
  /// In en, this message translates to:
  /// **'Classic fanfare'**
  String get done1;

  /// No description provided for @done2.
  ///
  /// In en, this message translates to:
  /// **'Rising fanfare'**
  String get done2;

  /// No description provided for @done3.
  ///
  /// In en, this message translates to:
  /// **'Bright finale'**
  String get done3;

  /// No description provided for @doneFanfareSub.
  ///
  /// In en, this message translates to:
  /// **'Plays at the end of all periods — choose one of 3 fanfares'**
  String get doneFanfareSub;

  /// No description provided for @durCompactHour.
  ///
  /// In en, this message translates to:
  /// **'{n} h'**
  String durCompactHour(String n);

  /// No description provided for @durCompactMin.
  ///
  /// In en, this message translates to:
  /// **'{n} m'**
  String durCompactMin(int n);

  /// No description provided for @durCompactSec.
  ///
  /// In en, this message translates to:
  /// **'{n} s'**
  String durCompactSec(int n);

  /// No description provided for @durHour.
  ///
  /// In en, this message translates to:
  /// **'{n} h'**
  String durHour(int n);

  /// No description provided for @durMin.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String durMin(int n);

  /// No description provided for @durNone.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get durNone;

  /// No description provided for @durSec.
  ///
  /// In en, this message translates to:
  /// **'{n} sec'**
  String durSec(int n);

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackup;

  /// No description provided for @exportCancelled.
  ///
  /// In en, this message translates to:
  /// **'Export cancelled.'**
  String get exportCancelled;

  /// No description provided for @exportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save {count, plural, =1{your settings and 1 workout to a .zip file} other{your settings and {count} workouts to a .zip file}}'**
  String exportSubtitle(int count);

  /// No description provided for @exportSubtitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Save your settings to a .zip file'**
  String get exportSubtitleEmpty;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackup;

  /// No description provided for @importBackupSub.
  ///
  /// In en, this message translates to:
  /// **'Replace settings and history from a .zip file'**
  String get importBackupSub;

  /// No description provided for @importCancelled.
  ///
  /// In en, this message translates to:
  /// **'Import cancelled.'**
  String get importCancelled;

  /// No description provided for @infoBadgeSemantics.
  ///
  /// In en, this message translates to:
  /// **'About and support'**
  String get infoBadgeSemantics;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'About & Support'**
  String get infoTitle;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get keepScreenOn;

  /// No description provided for @keepScreenOnSub.
  ///
  /// In en, this message translates to:
  /// **'Prevent display sleep while timer is running'**
  String get keepScreenOnSub;

  /// No description provided for @labelFrequency.
  ///
  /// In en, this message translates to:
  /// **'FREQUENCY'**
  String get labelFrequency;

  /// No description provided for @labelRestInterval.
  ///
  /// In en, this message translates to:
  /// **'REST INTERVAL'**
  String get labelRestInterval;

  /// No description provided for @labelSets.
  ///
  /// In en, this message translates to:
  /// **'SETS'**
  String get labelSets;

  /// No description provided for @labelWorkoutInterval.
  ///
  /// In en, this message translates to:
  /// **'WORKOUT INTERVAL'**
  String get labelWorkoutInterval;

  /// No description provided for @languageSub.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language, or follow the system setting'**
  String get languageSub;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get lastWeek;

  /// No description provided for @monthsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String monthsCount(int count);

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStatistics;

  /// No description provided for @navTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get navTimer;

  /// No description provided for @networkWarning.
  ///
  /// In en, this message translates to:
  /// **'Send only on the selected network. Ethereum and BNB Chain share one address, so the network you send on is what decides where the funds land.'**
  String get networkWarning;

  /// No description provided for @noTraining.
  ///
  /// In en, this message translates to:
  /// **'no training'**
  String get noTraining;

  /// No description provided for @noWorkoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkoutsYet;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'OVERVIEW'**
  String get overview;

  /// No description provided for @periodDay.
  ///
  /// In en, this message translates to:
  /// **'DAY'**
  String get periodDay;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'MONTH'**
  String get periodMonth;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'WEEK'**
  String get periodWeek;

  /// No description provided for @prestartInstant.
  ///
  /// In en, this message translates to:
  /// **'instant'**
  String get prestartInstant;

  /// No description provided for @prestartOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get prestartOff;

  /// No description provided for @prestartSub.
  ///
  /// In en, this message translates to:
  /// **'Countdown before the first interval — set 0 to start instantly'**
  String get prestartSub;

  /// No description provided for @progressBar.
  ///
  /// In en, this message translates to:
  /// **'Progress bar'**
  String get progressBar;

  /// No description provided for @progressBarSub.
  ///
  /// In en, this message translates to:
  /// **'Show or hide total completion progress'**
  String get progressBarSub;

  /// No description provided for @purposeBullet1.
  ///
  /// In en, this message translates to:
  /// **'Set the work interval, rest, sets and tick frequency, then start. Audio cues mark every tick and every change of phase, so the phone can stay in your pocket.'**
  String get purposeBullet1;

  /// No description provided for @purposeBullet2.
  ///
  /// In en, this message translates to:
  /// **'The screen stays awake while a session runs, and a countdown gives you time to get into position.'**
  String get purposeBullet2;

  /// No description provided for @purposeBullet3.
  ///
  /// In en, this message translates to:
  /// **'Finished sessions are recorded. Statistics shows your totals, streaks and a bar chart of training time by day, week or month.'**
  String get purposeBullet3;

  /// No description provided for @purposeBullet4.
  ///
  /// In en, this message translates to:
  /// **'Everything is stored on your device. Settings and history can be exported to a backup file and restored later.'**
  String get purposeBullet4;

  /// No description provided for @purposeIntro.
  ///
  /// In en, this message translates to:
  /// **'Interval Timer runs work-and-rest workouts — HIIT, circuits, stretching, breathing drills — so you can keep your eyes off the screen and your hands free.'**
  String get purposeIntro;

  /// No description provided for @qrSemantics.
  ///
  /// In en, this message translates to:
  /// **'{name} donation QR code'**
  String qrSemantics(String name);

  /// No description provided for @recordDetail.
  ///
  /// In en, this message translates to:
  /// **'Units {units}  ·  Rest {rest}s  ·  Sets {sets}  ·  Freq {freq}s'**
  String recordDetail(int units, int rest, int sets, String freq);

  /// No description provided for @replaceWarning.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This replaces your current settings and 1 saved workout. That cannot be undone.} other{This replaces your current settings and {count} saved workouts. That cannot be undone.}}'**
  String replaceWarning(int count);

  /// No description provided for @replaceWarningEmpty.
  ///
  /// In en, this message translates to:
  /// **'This replaces your current settings. You have no saved workouts to lose.'**
  String get replaceWarningEmpty;

  /// No description provided for @restoreDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get restoreDialogTitle;

  /// No description provided for @sectionBackup.
  ///
  /// In en, this message translates to:
  /// **'BACKUP'**
  String get sectionBackup;

  /// No description provided for @sectionDoneFanfare.
  ///
  /// In en, this message translates to:
  /// **'DONE FANFARE'**
  String get sectionDoneFanfare;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get sectionGeneral;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get sectionLanguage;

  /// No description provided for @sectionPrestart.
  ///
  /// In en, this message translates to:
  /// **'PRESTART'**
  String get sectionPrestart;

  /// No description provided for @sectionTickSound.
  ///
  /// In en, this message translates to:
  /// **'TICK SOUND'**
  String get sectionTickSound;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String sessionsCount(int count);

  /// No description provided for @setWord.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setWord;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get statusRest;

  /// No description provided for @statusStartIn.
  ///
  /// In en, this message translates to:
  /// **'Start in'**
  String get statusStartIn;

  /// No description provided for @statusWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get statusWorkout;

  /// No description provided for @subGetReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready'**
  String get subGetReady;

  /// No description provided for @subGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get subGreatJob;

  /// No description provided for @subSetProgress.
  ///
  /// In en, this message translates to:
  /// **'Set {current}/{total} • intervals left'**
  String subSetProgress(int current, int total);

  /// No description provided for @subTapResume.
  ///
  /// In en, this message translates to:
  /// **'Tap resume to continue'**
  String get subTapResume;

  /// No description provided for @subUntilNext.
  ///
  /// In en, this message translates to:
  /// **'Until next period'**
  String get subUntilNext;

  /// No description provided for @supportDevelopment.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT DEVELOPMENT'**
  String get supportDevelopment;

  /// No description provided for @supportIntro.
  ///
  /// In en, this message translates to:
  /// **'The app is free, has no ads and collects nothing. If it is useful to you, a tip is welcome — pick a network and scan or copy the address.'**
  String get supportIntro;

  /// No description provided for @tapAnywhereToResume.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to resume'**
  String get tapAnywhereToResume;

  /// No description provided for @tapBarForDetail.
  ///
  /// In en, this message translates to:
  /// **'tap a bar for detail'**
  String get tapBarForDetail;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @tick1.
  ///
  /// In en, this message translates to:
  /// **'Soft click'**
  String get tick1;

  /// No description provided for @tick2.
  ///
  /// In en, this message translates to:
  /// **'Double click'**
  String get tick2;

  /// No description provided for @tick3.
  ///
  /// In en, this message translates to:
  /// **'Alert click'**
  String get tick3;

  /// No description provided for @tick4.
  ///
  /// In en, this message translates to:
  /// **'Punchy click'**
  String get tick4;

  /// No description provided for @tick5.
  ///
  /// In en, this message translates to:
  /// **'Triple click'**
  String get tick5;

  /// No description provided for @tick6.
  ///
  /// In en, this message translates to:
  /// **'Bright click'**
  String get tick6;

  /// No description provided for @tickSoundSub.
  ///
  /// In en, this message translates to:
  /// **'Plays at every workout unit — choose one of 6 short clicks'**
  String get tickSoundSub;

  /// No description provided for @timerSignal.
  ///
  /// In en, this message translates to:
  /// **'Timer signal'**
  String get timerSignal;

  /// No description provided for @timerSignalSub.
  ///
  /// In en, this message translates to:
  /// **'Play signal at every workout unit'**
  String get timerSignalSub;

  /// No description provided for @totalProgress.
  ///
  /// In en, this message translates to:
  /// **'Total progress {percent}%'**
  String totalProgress(String percent);

  /// No description provided for @totalSuffix.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec total'**
  String totalSuffix(int seconds);

  /// No description provided for @trainingTime.
  ///
  /// In en, this message translates to:
  /// **'TRAINING TIME'**
  String get trainingTime;

  /// No description provided for @unitIntervals.
  ///
  /// In en, this message translates to:
  /// **'intervals'**
  String get unitIntervals;

  /// No description provided for @unitSec.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get unitSec;

  /// No description provided for @unitUnits.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get unitUnits;

  /// No description provided for @valueDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get valueDone;

  /// No description provided for @weeksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week} other{{count} weeks}}'**
  String weeksCount(int count);

  /// No description provided for @whatThisAppIsFor.
  ///
  /// In en, this message translates to:
  /// **'What this app is for'**
  String get whatThisAppIsFor;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ka',
        'ru'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ka':
      return AppLocalizationsKa();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
