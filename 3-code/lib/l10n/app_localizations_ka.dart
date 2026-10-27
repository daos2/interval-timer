// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get actionCancel => 'გაუქმება';

  @override
  String get actionCopy => 'კოპირება';

  @override
  String get actionNewSession => 'ახალი სესია';

  @override
  String get actionPause => 'პაუზა';

  @override
  String get actionReplace => 'ჩანაცვლება';

  @override
  String get actionReset => 'გადატვირთვა';

  @override
  String get actionResume => 'გაგრძელება';

  @override
  String get actionStart => 'დაწყება';

  @override
  String addressCopied(String name) {
    return '$name-ის მისამართი დაკოპირდა';
  }

  @override
  String backedUpOn(String date, String version) {
    return 'შექმნილია $date$version:';
  }

  @override
  String get backupContents => 'ასლის შიგთავსი:';

  @override
  String backupReadFailed(String error) {
    return 'ასლის წაკითხვა ვერ მოხერხდა: $error';
  }

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'აღდგენილია $count ვარჯიში და პარამეტრები.',
      one: 'აღდგენილია $count ვარჯიში და პარამეტრები.',
    );
    return '$_temp0';
  }

  @override
  String backupSaveFailed(String error) {
    return 'ასლის შენახვა ვერ მოხერხდა: $error';
  }

  @override
  String backupSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ასლი შენახულია — $count ვარჯიში და პარამეტრები.',
      one: 'ასლი შენახულია — $count ვარჯიში და პარამეტრები.',
    );
    return '$_temp0';
  }

  @override
  String get backupSub =>
      'შეინახეთ პარამეტრები და ისტორია .zip ფაილში ან აღადგინეთ';

  @override
  String get bulletAllSettings => '• ყველა პარამეტრი';

  @override
  String bulletWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '• $count ვარჯიში',
      one: '• $count ვარჯიში',
    );
    return '$_temp0';
  }

  @override
  String get chainBitcoin => 'Bitcoin-ის ქსელი';

  @override
  String get completedLabel => 'დასრულებული';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count დღე',
      one: '$count დღე',
    );
    return '$_temp0';
  }

  @override
  String get dialogChooseBackup => 'აირჩიეთ Interval Timer-ის ასლი';

  @override
  String get dialogSaveBackup => 'Interval Timer-ის ასლის შენახვა';

  @override
  String get done1 => 'კლასიკური ფანფარა';

  @override
  String get done2 => 'ამღმავალი ფანფარა';

  @override
  String get done3 => 'ნათელი ფინალი';

  @override
  String get doneFanfareSub =>
      'ჟღერს ყველა პერიოდის ბოლოს — აირჩიეთ 3 ფანფარიდან';

  @override
  String durCompactHour(String n) {
    return '$n სთ';
  }

  @override
  String durCompactMin(int n) {
    return '$n წთ';
  }

  @override
  String durCompactSec(int n) {
    return '$n წმ';
  }

  @override
  String durHour(int n) {
    return '$n სთ';
  }

  @override
  String durMin(int n) {
    return '$n წთ';
  }

  @override
  String get durNone => '—';

  @override
  String durSec(int n) {
    return '$n წმ';
  }

  @override
  String get exportBackup => 'ასლის ექსპორტი';

  @override
  String get exportCancelled => 'ექსპორტი გაუქმდა.';

  @override
  String exportSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'პარამეტრები და $count ვარჯიში .zip ფაილში',
      one: 'პარამეტრები და $count ვარჯიში .zip ფაილში',
    );
    return 'Save $_temp0';
  }

  @override
  String get exportSubtitleEmpty => 'შეინახეთ პარამეტრები .zip ფაილში';

  @override
  String get importBackup => 'ასლის იმპორტი';

  @override
  String get importBackupSub =>
      'პარამეტრებისა და ისტორიის ჩანაცვლება .zip ფაილიდან';

  @override
  String get importCancelled => 'იმპორტი გაუქმდა.';

  @override
  String get infoBadgeSemantics => 'შესახებ და მხარდაჭერა';

  @override
  String get infoTitle => 'შესახებ და მხარდაჭერა';

  @override
  String get keepScreenOn => 'ეკრანი ჩართული დარჩეს';

  @override
  String get keepScreenOnSub => 'ტაიმერის მუშაობისას ეკრანი არ ჩაქრება';

  @override
  String get labelFrequency => 'სიხშირე';

  @override
  String get labelRestInterval => 'დასვენების ინტერვალი';

  @override
  String get labelSets => 'სეტები';

  @override
  String get labelWorkoutInterval => 'ვარჯიშის ინტერვალი';

  @override
  String get languageSub => 'აირჩიეთ ენა ან მიჰყევით სისტემის პარამეტრს';

  @override
  String get languageSystem => 'სისტემური';

  @override
  String get lastWeek => 'გასული კვირა';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count თვე',
      one: '$count თვე',
    );
    return '$_temp0';
  }

  @override
  String get navSettings => 'პარამეტრები';

  @override
  String get navStatistics => 'სტატისტიკა';

  @override
  String get navTimer => 'ტაიმერი';

  @override
  String get networkWarning =>
      'გაგზავნეთ მხოლოდ არჩეულ ქსელში. Ethereum და BNB Chain ერთ მისამართს იყენებს, ამიტომ ქსელი განსაზღვრავს სახსრების დანიშნულებას.';

  @override
  String get noTraining => 'ვარჯიშის გარეშე';

  @override
  String get noWorkoutsYet => 'ჯერ ვარჯიშები არ არის';

  @override
  String get overview => 'მიმოხილვა';

  @override
  String get periodDay => 'დღე';

  @override
  String get periodMonth => 'თვე';

  @override
  String get periodWeek => 'კვირა';

  @override
  String get prestartInstant => 'მყისიერი';

  @override
  String get prestartOff => 'გამორთ.';

  @override
  String get prestartSub => 'ათვლა პირველ ინტერვალამდე — 0 იწყებს მაშინვე';

  @override
  String get progressBar => 'პროგრესის ზოლი';

  @override
  String get progressBarSub => 'საერთო პროგრესის ჩვენება';

  @override
  String get purposeBullet1 =>
      'დააყენეთ სამუშაო, დასვენება, სეტები და სიხშირე და დაიწყეთ. ხმოვანი სიგნალები აღნიშნავს ყოველ წკაპსა და ფაზის ცვლილებას.';

  @override
  String get purposeBullet2 =>
      'სესიის დროს ეკრანი ჩართული რჩება, ათვლა კი მოსამზადებელ დროს გაძლევთ.';

  @override
  String get purposeBullet3 =>
      'დასრულებული სესიები ინახება. სტატისტიკა აჩვენებს ჯამებს და დიაგრამას დღის, კვირის ან თვის მიხედვით.';

  @override
  String get purposeBullet4 =>
      'ყველაფერი ინახება თქვენს მოწყობილობაზე. პარამეტრები და ისტორია შეიძლება შეინახოთ და აღადგინოთ.';

  @override
  String get purposeIntro =>
      'Interval Timer უძღვება ვარჯიშს სამუშაო-დასვენების რეჟიმში — HIIT, წრიული, გაჭიმვა, სუნთქვა — რომ ეკრანს არ უყუროთ და ხელები თავისუფალი გქონდეთ.';

  @override
  String qrSemantics(String name) {
    return '$name-ის შემოწირულობის QR კოდი';
  }

  @override
  String recordDetail(int units, int rest, int sets, String freq) {
    return 'ერთ. $units  ·  დასვენება $restწმ  ·  სეტები $sets  ·  სიხშირე $freqწმ';
  }

  @override
  String replaceWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ეს ჩაანაცვლებს პარამეტრებს და $count შენახულ ვარჯიშს. ვერ გაუქმდება.',
      one:
          'ეს ჩაანაცვლებს პარამეტრებს და $count შენახულ ვარჯიშს. ვერ გაუქმდება.',
    );
    return '$_temp0';
  }

  @override
  String get replaceWarningEmpty =>
      'ეს ჩაანაცვლებს მიმდინარე პარამეტრებს. შენახული ვარჯიშები არ გაქვთ.';

  @override
  String get restoreDialogTitle => 'აღდგეს ეს ასლი?';

  @override
  String get sectionBackup => 'სარეზერვო ასლი';

  @override
  String get sectionDoneFanfare => 'დასრულების ფანფარა';

  @override
  String get sectionGeneral => 'ზოგადი';

  @override
  String get sectionLanguage => 'ენა';

  @override
  String get sectionPrestart => 'წინასტარტი';

  @override
  String get sectionTickSound => 'ტკიპის ხმა';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count სესია',
      one: '$count სესია',
    );
    return '$_temp0';
  }

  @override
  String get setWord => 'სეტი';

  @override
  String get settingsTitle => 'პარამეტრები';

  @override
  String get statisticsTitle => 'სტატისტიკა';

  @override
  String get statusCompleted => 'დასრულდა';

  @override
  String get statusPaused => 'შეჩერებულია';

  @override
  String get statusReady => 'მზადაა';

  @override
  String get statusRest => 'დასვენება';

  @override
  String get statusStartIn => 'დაწყება';

  @override
  String get statusWorkout => 'ვარჯიში';

  @override
  String get subGetReady => 'მოემზადეთ';

  @override
  String get subGreatJob => 'შესანიშნავია!';

  @override
  String subSetProgress(int current, int total) {
    return 'სეტი $current/$total • დარჩენილი ინტერვალები';
  }

  @override
  String get subTapResume => 'გასაგრძელებლად შეეხეთ';

  @override
  String get subUntilNext => 'შემდეგ პერიოდამდე';

  @override
  String get supportDevelopment => 'მხარდაჭერა';

  @override
  String get supportIntro =>
      'აპი უფასოა, რეკლამის გარეშე და არაფერს აგროვებს. თუ სასარგებლოა, მადლობელი ვიქნები — აირჩიეთ ქსელი და დაასკანერეთ ან დააკოპირეთ მისამართი.';

  @override
  String get tapAnywhereToResume => 'გასაგრძელებლად შეეხეთ ეკრანს';

  @override
  String get tapBarForDetail => 'შეეხეთ სვეტს დეტალებისთვის';

  @override
  String get thisWeek => 'ეს კვირა';

  @override
  String get tick1 => 'რბილი წკაპი';

  @override
  String get tick2 => 'ორმაგი წკაპი';

  @override
  String get tick3 => 'სიგნალური წკაპი';

  @override
  String get tick4 => 'მკვეთრი წკაპი';

  @override
  String get tick5 => 'სამმაგი წკაპი';

  @override
  String get tick6 => 'ნათელი წკაპი';

  @override
  String get tickSoundSub => 'ჟღერს ყოველ ერთეულზე — აირჩიეთ 6 მოკლე წკაპიდან';

  @override
  String get timerSignal => 'ხმოვანი სიგნალი';

  @override
  String get timerSignalSub => 'სიგნალი ყოველ ერთეულზე';

  @override
  String totalProgress(String percent) {
    return 'საერთო პროგრესი $percent%';
  }

  @override
  String totalSuffix(int seconds) {
    return 'სულ $seconds წმ';
  }

  @override
  String get trainingTime => 'ვარჯიშის დრო';

  @override
  String get unitIntervals => 'ინტერვალი';

  @override
  String get unitSec => 'წმ';

  @override
  String get unitUnits => 'ერთეული';

  @override
  String get valueDone => 'დასრულდა';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count კვირა',
      one: '$count კვირა',
    );
    return '$_temp0';
  }

  @override
  String get whatThisAppIsFor => 'რისთვის არის ეს აპი';
}
