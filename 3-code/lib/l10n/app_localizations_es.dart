// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get actionNewSession => 'NUEVA SESIÓN';

  @override
  String get actionPause => 'PAUSA';

  @override
  String get actionReplace => 'Reemplazar';

  @override
  String get actionReset => 'REINICIAR';

  @override
  String get actionResume => 'REANUDAR';

  @override
  String get actionStart => 'INICIAR';

  @override
  String addressCopied(String name) {
    return 'Dirección de $name copiada';
  }

  @override
  String backedUpOn(String date, String version) {
    return 'Copia del $date$version:';
  }

  @override
  String get backupContents => 'Contenido de la copia:';

  @override
  String backupReadFailed(String error) {
    return 'No se pudo leer esa copia: $error';
  }

  @override
  String backupRestored(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restaurados $count entrenamientos y tus ajustes.',
      one: 'Restaurado 1 entrenamiento y tus ajustes.',
    );
    return '$_temp0';
  }

  @override
  String backupSaveFailed(String error) {
    return 'No se pudo guardar la copia: $error';
  }

  @override
  String backupSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copia guardada — $count entrenamientos y tus ajustes.',
      one: 'Copia guardada — 1 entrenamiento y tus ajustes.',
    );
    return '$_temp0';
  }

  @override
  String get backupSub =>
      'Guarda los ajustes y el historial en un archivo .zip, o restáuralos';

  @override
  String get bulletAllSettings => '• Todos los ajustes';

  @override
  String bulletWorkouts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '• $count entrenamientos',
      one: '• 1 entrenamiento',
    );
    return '$_temp0';
  }

  @override
  String get chainBitcoin => 'Red Bitcoin';

  @override
  String get completedLabel => 'Completados';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get dialogChooseBackup => 'Elegir una copia de Interval Timer';

  @override
  String get dialogSaveBackup => 'Guardar copia de Interval Timer';

  @override
  String get done1 => 'Fanfarria clásica';

  @override
  String get done2 => 'Fanfarria ascendente';

  @override
  String get done3 => 'Final brillante';

  @override
  String get doneFanfareSub =>
      'Suena al final de todos los periodos — elige una de 3 fanfarrias';

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
  String get exportBackup => 'Exportar copia';

  @override
  String get exportCancelled => 'Exportación cancelada.';

  @override
  String exportSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tus ajustes y $count entrenamientos en un .zip',
      one: 'tus ajustes y 1 entrenamiento en un .zip',
    );
    return 'Save $_temp0';
  }

  @override
  String get exportSubtitleEmpty => 'Guarda tus ajustes en un .zip';

  @override
  String get importBackup => 'Importar copia';

  @override
  String get importBackupSub => 'Reemplazar ajustes e historial desde un .zip';

  @override
  String get importCancelled => 'Importación cancelada.';

  @override
  String get infoBadgeSemantics => 'Acerca de y apoyo';

  @override
  String get infoTitle => 'Acerca de y apoyo';

  @override
  String get keepScreenOn => 'Mantener pantalla encendida';

  @override
  String get keepScreenOnSub =>
      'Evita que la pantalla se apague con el temporizador activo';

  @override
  String get labelFrequency => 'FRECUENCIA';

  @override
  String get labelRestInterval => 'INTERVALO DE DESCANSO';

  @override
  String get labelSets => 'SERIES';

  @override
  String get labelWorkoutInterval => 'INTERVALO DE TRABAJO';

  @override
  String get languageSub =>
      'Elige el idioma de la app, o sigue el ajuste del sistema';

  @override
  String get languageSystem => 'Idioma del sistema';

  @override
  String get lastWeek => 'La semana pasada';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mes',
    );
    return '$_temp0';
  }

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navStatistics => 'Estadísticas';

  @override
  String get navTimer => 'Temporizador';

  @override
  String get networkWarning =>
      'Envía solo en la red seleccionada. Ethereum y BNB Chain comparten una dirección, así que la red decide dónde llegan los fondos.';

  @override
  String get noTraining => 'sin entrenamiento';

  @override
  String get noWorkoutsYet => 'Aún no hay entrenamientos';

  @override
  String get overview => 'RESUMEN';

  @override
  String get periodDay => 'DÍA';

  @override
  String get periodMonth => 'MES';

  @override
  String get periodWeek => 'SEMANA';

  @override
  String get prestartInstant => 'instantáneo';

  @override
  String get prestartOff => 'Desactivado';

  @override
  String get prestartSub =>
      'Cuenta atrás antes del primer intervalo — 0 para empezar al instante';

  @override
  String get progressBar => 'Barra de progreso';

  @override
  String get progressBarSub => 'Mostrar u ocultar el progreso total';

  @override
  String get purposeBullet1 =>
      'Ajusta trabajo, descanso, series y frecuencia, y empieza. Las señales marcan cada tic y cada cambio de fase, así el móvil puede quedarse en el bolsillo.';

  @override
  String get purposeBullet2 =>
      'La pantalla permanece encendida durante la sesión y una cuenta atrás te da tiempo a colocarte.';

  @override
  String get purposeBullet3 =>
      'Las sesiones terminadas se registran. Estadísticas muestra totales, rachas y un gráfico por día, semana o mes.';

  @override
  String get purposeBullet4 =>
      'Todo se guarda en tu dispositivo. Ajustes e historial se pueden exportar y restaurar.';

  @override
  String get purposeIntro =>
      'Interval Timer ejecuta entrenamientos de trabajo y descanso — HIIT, circuitos, estiramientos, respiración — para no mirar la pantalla y tener las manos libres.';

  @override
  String qrSemantics(String name) {
    return 'Código QR de donación de $name';
  }

  @override
  String recordDetail(int units, int rest, int sets, String freq) {
    return 'Unidades $units  ·  Descanso ${rest}s  ·  Series $sets  ·  Frec. ${freq}s';
  }

  @override
  String replaceWarning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Esto reemplaza tus ajustes y $count entrenamientos guardados. No se puede deshacer.',
      one:
          'Esto reemplaza tus ajustes y 1 entrenamiento guardado. No se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String get replaceWarningEmpty =>
      'Esto reemplaza tus ajustes actuales. No tienes entrenamientos guardados que perder.';

  @override
  String get restoreDialogTitle => '¿Restaurar esta copia?';

  @override
  String get sectionBackup => 'COPIA DE SEGURIDAD';

  @override
  String get sectionDoneFanfare => 'FANFARRIA FINAL';

  @override
  String get sectionGeneral => 'GENERAL';

  @override
  String get sectionLanguage => 'IDIOMA';

  @override
  String get sectionPrestart => 'CUENTA ATRÁS';

  @override
  String get sectionTickSound => 'SONIDO DE TIC';

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones',
      one: '1 sesión',
    );
    return '$_temp0';
  }

  @override
  String get setWord => 'Serie';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get statisticsTitle => 'Estadísticas';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusPaused => 'En pausa';

  @override
  String get statusReady => 'Listo';

  @override
  String get statusRest => 'Descanso';

  @override
  String get statusStartIn => 'Comienza en';

  @override
  String get statusWorkout => 'Trabajo';

  @override
  String get subGetReady => 'Prepárate';

  @override
  String get subGreatJob => '¡Buen trabajo!';

  @override
  String subSetProgress(int current, int total) {
    return 'Serie $current/$total • intervalos restantes';
  }

  @override
  String get subTapResume => 'Toca Reanudar para continuar';

  @override
  String get subUntilNext => 'Hasta el siguiente periodo';

  @override
  String get supportDevelopment => 'APOYAR EL DESARROLLO';

  @override
  String get supportIntro =>
      'La app es gratuita, sin anuncios y no recoge nada. Si te resulta útil, se agradece una propina — elige una red y escanea o copia la dirección.';

  @override
  String get tapAnywhereToResume => 'Toca en cualquier lugar para reanudar';

  @override
  String get tapBarForDetail => 'toca una barra para ver detalles';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get tick1 => 'Clic suave';

  @override
  String get tick2 => 'Clic doble';

  @override
  String get tick3 => 'Clic de alerta';

  @override
  String get tick4 => 'Clic marcado';

  @override
  String get tick5 => 'Clic triple';

  @override
  String get tick6 => 'Clic brillante';

  @override
  String get tickSoundSub =>
      'Suena en cada unidad de trabajo — elige uno de 6 clics cortos';

  @override
  String get timerSignal => 'Señal sonora';

  @override
  String get timerSignalSub => 'Suena en cada unidad de trabajo';

  @override
  String totalProgress(String percent) {
    return 'Progreso total $percent%';
  }

  @override
  String totalSuffix(int seconds) {
    return '$seconds s en total';
  }

  @override
  String get trainingTime => 'TIEMPO DE ENTRENAMIENTO';

  @override
  String get unitIntervals => 'intervalos';

  @override
  String get unitSec => 's';

  @override
  String get unitUnits => 'unidades';

  @override
  String get valueDone => 'Hecho';

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '1 semana',
    );
    return '$_temp0';
  }

  @override
  String get whatThisAppIsFor => 'Para qué sirve esta app';
}
