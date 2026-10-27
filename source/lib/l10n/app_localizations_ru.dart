// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionCopy => 'Копировать';

  @override
  String get actionNewSession => 'НОВАЯ СЕССИЯ';

  @override
  String get actionPause => 'ПАУЗА';

  @override
  String get actionReplace => 'Заменить';

  @override
  String get actionReset => 'СБРОС';

  @override
  String get actionResume => 'ПРОДОЛЖИТЬ';

  @override
  String get actionStart => 'СТАРТ';

  @override
  String addressCopied(String name) {
    return 'Адрес $name скопирован';
  }

  @override
  String backedUpOn(String date, String version) {
    return 'Создано $date$version:';
  }

  @override
  String get backupContents => 'Содержимое копии:';

  @override
  String backupReadFailed(String error) {
    return 'Не удалось прочитать копию: $error';
  }

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Восстановлено $count тренировки и настройки.',
      many: 'Восстановлено $count тренировок и настройки.',
      few: 'Восстановлено $count тренировки и настройки.',
      one: 'Восстановлена $count тренировка и настройки.',
    );
    return '$_temp0';
  }

  @override
  String backupSaveFailed(String error) {
    return 'Не удалось сохранить копию: $error';
  }

  @override
  String backupSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Копия сохранена — $count тренировки и настройки.',
      many: 'Копия сохранена — $count тренировок и настройки.',
      few: 'Копия сохранена — $count тренировки и настройки.',
      one: 'Копия сохранена — $count тренировка и настройки.',
    );
    return '$_temp0';
  }

  @override
  String get backupSub =>
      'Сохраните настройки и историю в .zip или восстановите их из файла';

  @override
  String get bulletAllSettings => '• Все настройки приложения';

  @override
  String bulletWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '• $count тренировки',
      many: '• $count тренировок',
      few: '• $count тренировки',
      one: '• $count тренировка',
    );
    return '$_temp0';
  }

  @override
  String get chainBitcoin => 'Сеть Bitcoin';

  @override
  String get completedLabel => 'Завершено';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String get dialogChooseBackup => 'Выберите копию Interval Timer';

  @override
  String get dialogSaveBackup => 'Сохранить копию Interval Timer';

  @override
  String get done1 => 'Классический сигнал';

  @override
  String get done2 => 'Восходящий сигнал';

  @override
  String get done3 => 'Яркий финал';

  @override
  String get doneFanfareSub =>
      'Звучит в конце всех периодов — выберите один из 3 сигналов';

  @override
  String durCompactHour(String n) {
    return '$n ч';
  }

  @override
  String durCompactMin(int n) {
    return '$n м';
  }

  @override
  String durCompactSec(int n) {
    return '$n с';
  }

  @override
  String durHour(int n) {
    return '$n ч';
  }

  @override
  String durMin(int n) {
    return '$n мин';
  }

  @override
  String get durNone => '—';

  @override
  String durSec(int n) {
    return '$n сек';
  }

  @override
  String get exportBackup => 'Экспорт копии';

  @override
  String get exportCancelled => 'Экспорт отменён.';

  @override
  String exportSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'настройки и $count тренировки в .zip',
      many: 'настройки и $count тренировок в .zip',
      few: 'настройки и $count тренировки в .zip',
      one: 'настройки и $count тренировку в .zip',
    );
    return 'Save $_temp0';
  }

  @override
  String get exportSubtitleEmpty => 'Сохранить настройки в .zip';

  @override
  String get importBackup => 'Импорт копии';

  @override
  String get importBackupSub => 'Заменить настройки и историю из .zip';

  @override
  String get importCancelled => 'Импорт отменён.';

  @override
  String get infoBadgeSemantics => 'О программе и поддержка';

  @override
  String get infoTitle => 'О программе и поддержка';

  @override
  String get keepScreenOn => 'Не выключать экран';

  @override
  String get keepScreenOnSub => 'Экран не гаснет, пока работает таймер';

  @override
  String get labelFrequency => 'ЧАСТОТА';

  @override
  String get labelRestInterval => 'ИНТЕРВАЛ ОТДЫХА';

  @override
  String get labelSets => 'ПОДХОДЫ';

  @override
  String get labelWorkoutInterval => 'ИНТЕРВАЛ РАБОТЫ';

  @override
  String get languageSub =>
      'Выберите язык приложения или следуйте системной настройке';

  @override
  String get languageSystem => 'Системный';

  @override
  String get lastWeek => 'Прошлая неделя';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месяца',
      many: '$count месяцев',
      few: '$count месяца',
      one: '$count месяц',
    );
    return '$_temp0';
  }

  @override
  String get navSettings => 'Настройки';

  @override
  String get navStatistics => 'Статистика';

  @override
  String get navTimer => 'Таймер';

  @override
  String get networkWarning =>
      'Отправляйте только в выбранной сети. Ethereum и BNB Chain используют один адрес, и именно сеть определяет, куда придут средства.';

  @override
  String get noTraining => 'без тренировок';

  @override
  String get noWorkoutsYet => 'Пока нет тренировок';

  @override
  String get overview => 'ОБЗОР';

  @override
  String get periodDay => 'ДЕНЬ';

  @override
  String get periodMonth => 'МЕСЯЦ';

  @override
  String get periodWeek => 'НЕДЕЛЯ';

  @override
  String get prestartInstant => 'сразу';

  @override
  String get prestartOff => 'Выкл';

  @override
  String get prestartSub =>
      'Отсчёт перед первым интервалом — 0 запускает сразу';

  @override
  String get progressBar => 'Полоса прогресса';

  @override
  String get progressBarSub => 'Показывать общий прогресс';

  @override
  String get purposeBullet1 =>
      'Задайте работу, отдых, подходы и частоту — и начните. Звуки отмечают каждый тик и смену фазы, телефон может остаться в кармане.';

  @override
  String get purposeBullet2 =>
      'Экран не гаснет во время сессии, а отсчёт даёт время занять позицию.';

  @override
  String get purposeBullet3 =>
      'Завершённые сессии записываются. Статистика показывает итоги, серии и график по дням, неделям или месяцам.';

  @override
  String get purposeBullet4 =>
      'Всё хранится на устройстве. Настройки и историю можно выгрузить в файл и восстановить.';

  @override
  String get purposeIntro =>
      'Interval Timer ведёт тренировки «работа-отдых» — HIIT, круговые, растяжка, дыхание — чтобы не смотреть на экран и держать руки свободными.';

  @override
  String qrSemantics(String name) {
    return 'QR-код для доната $name';
  }

  @override
  String recordDetail(int units, int rest, int sets, String freq) {
    return 'Ед. $units  ·  Отдых $restс  ·  Подходы $sets  ·  Частота $freqс';
  }

  @override
  String replaceWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Это заменит настройки и $count сохранённые тренировки. Отменить нельзя.',
      many:
          'Это заменит настройки и $count сохранённых тренировок. Отменить нельзя.',
      few:
          'Это заменит настройки и $count сохранённые тренировки. Отменить нельзя.',
      one:
          'Это заменит настройки и $count сохранённую тренировку. Отменить нельзя.',
    );
    return '$_temp0';
  }

  @override
  String get replaceWarningEmpty =>
      'Это заменит текущие настройки. Сохранённых тренировок нет.';

  @override
  String get restoreDialogTitle => 'Восстановить эту копию?';

  @override
  String get sectionBackup => 'РЕЗЕРВНАЯ КОПИЯ';

  @override
  String get sectionDoneFanfare => 'ФИНАЛЬНЫЙ СИГНАЛ';

  @override
  String get sectionGeneral => 'ОБЩИЕ';

  @override
  String get sectionLanguage => 'ЯЗЫК';

  @override
  String get sectionPrestart => 'ПРЕДСТАРТ';

  @override
  String get sectionTickSound => 'ЗВУК ТИКА';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сессии',
      many: '$count сессий',
      few: '$count сессии',
      one: '$count сессия',
    );
    return '$_temp0';
  }

  @override
  String get setWord => 'Подход';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get statisticsTitle => 'Статистика';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get statusPaused => 'Пауза';

  @override
  String get statusReady => 'Готово';

  @override
  String get statusRest => 'Отдых';

  @override
  String get statusStartIn => 'Старт через';

  @override
  String get statusWorkout => 'Работа';

  @override
  String get subGetReady => 'Приготовьтесь';

  @override
  String get subGreatJob => 'Отлично!';

  @override
  String subSetProgress(int current, int total) {
    return 'Подход $current/$total • осталось интервалов';
  }

  @override
  String get subTapResume => 'Нажмите «Продолжить»';

  @override
  String get subUntilNext => 'До следующего периода';

  @override
  String get supportDevelopment => 'ПОДДЕРЖАТЬ РАЗРАБОТКУ';

  @override
  String get supportIntro =>
      'Приложение бесплатное, без рекламы и ничего не собирает. Если оно полезно, буду рад донату — выберите сеть и отсканируйте или скопируйте адрес.';

  @override
  String get tapAnywhereToResume => 'Коснитесь экрана, чтобы продолжить';

  @override
  String get tapBarForDetail => 'нажмите на столбец для деталей';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String get tick1 => 'Мягкий щелчок';

  @override
  String get tick2 => 'Двойной щелчок';

  @override
  String get tick3 => 'Сигнальный щелчок';

  @override
  String get tick4 => 'Резкий щелчок';

  @override
  String get tick5 => 'Тройной щелчок';

  @override
  String get tick6 => 'Яркий щелчок';

  @override
  String get tickSoundSub =>
      'Звучит на каждой единице работы — выберите один из 6 щелчков';

  @override
  String get timerSignal => 'Звуковой сигнал';

  @override
  String get timerSignalSub => 'Звук на каждой единице работы';

  @override
  String totalProgress(String percent) {
    return 'Общий прогресс $percent%';
  }

  @override
  String totalSuffix(int seconds) {
    return 'всего $seconds сек';
  }

  @override
  String get trainingTime => 'ВРЕМЯ ТРЕНИРОВОК';

  @override
  String get unitIntervals => 'интервалов';

  @override
  String get unitSec => 'сек';

  @override
  String get unitUnits => 'ед.';

  @override
  String get valueDone => 'Готово';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count недели',
      many: '$count недель',
      few: '$count недели',
      one: '$count неделя',
    );
    return '$_temp0';
  }

  @override
  String get whatThisAppIsFor => 'Для чего это приложение';
}
