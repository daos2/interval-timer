import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../settings/app_settings.dart';
import '../statistics/workout_record.dart';

/// Raised when a chosen file is not a backup this app can restore. The message
/// is written to be shown to the user as-is.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// What a backup archive contained.
class BackupContents {
  const BackupContents({
    required this.settings,
    required this.history,
    this.exportedAt,
    this.appVersion,
  });

  final AppSettings settings;
  final List<WorkoutRecord> history;
  final DateTime? exportedAt;
  final String? appVersion;
}

/// Reads and writes the `.zip` backup that carries settings and workout
/// history between installs.
///
/// Layout of the archive:
///   manifest.json  — schema version, app version, export time, entry counts
///   settings.json  — one [AppSettings] object
///   history.json   — a list of [WorkoutRecord] objects, newest first
abstract final class BackupService {
  /// Bumped only when the archive layout changes incompatibly.
  static const int schemaVersion = 1;
  static const String appVersion = '1.5.1+7';

  /// "v1.4.0" -- what the app bar shows. The build number is dropped: it
  /// changes on every store upload and means nothing to a user.
  static String get displayVersion => 'v${appVersion.split('+').first}';

  static const String manifestEntry = 'manifest.json';
  static const String settingsEntry = 'settings.json';
  static const String historyEntry = 'history.json';

  /// e.g. `interval-timer-backup-2026-09-21_1815.zip`
  static String suggestedFileName(DateTime now) {
    String two(int v) => v.toString().padLeft(2, '0');
    return 'interval-timer-backup-'
        '${now.year}-${two(now.month)}-${two(now.day)}_'
        '${two(now.hour)}${two(now.minute)}.zip';
  }

  static Uint8List create({
    required AppSettings settings,
    required List<WorkoutRecord> history,
    DateTime? now,
  }) {
    final stamp = now ?? DateTime.now();
    const encoder = JsonEncoder.withIndent('  ');

    final manifest = <String, Object>{
      'schemaVersion': schemaVersion,
      'appVersion': appVersion,
      'exportedAt': stamp.toIso8601String(),
      'workoutCount': history.length,
      'completedCount': history.where((r) => r.completed).length,
    };

    final archive = Archive()
      ..add(ArchiveFile.string(manifestEntry, encoder.convert(manifest)))
      ..add(ArchiveFile.string(settingsEntry, encoder.convert(settings.toJson())))
      ..add(ArchiveFile.string(
          historyEntry, encoder.convert(history.map((r) => r.toJson()).toList())));

    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  static BackupContents read(Uint8List bytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw const BackupFormatException(
          'That file is not a readable .zip archive.');
    }

    final manifestRaw = _entryText(archive, manifestEntry);
    if (manifestRaw == null) {
      throw const BackupFormatException(
          'That .zip is not an Interval Timer backup (no manifest.json).');
    }

    final manifest = _asObject(manifestRaw, manifestEntry);
    final fileSchema = (manifest['schemaVersion'] as num?)?.toInt();
    if (fileSchema == null) {
      throw const BackupFormatException(
          'That backup is missing its schema version and cannot be read.');
    }
    if (fileSchema > schemaVersion) {
      throw BackupFormatException(
          'That backup was written by a newer version of the app '
          '(format $fileSchema, this build reads up to $schemaVersion).');
    }

    final settingsRaw = _entryText(archive, settingsEntry);
    final historyRaw = _entryText(archive, historyEntry);
    if (settingsRaw == null || historyRaw == null) {
      throw const BackupFormatException(
          'That backup is incomplete — settings.json or history.json is missing.');
    }

    final AppSettings settings;
    try {
      settings = AppSettings.fromJson(_asObject(settingsRaw, settingsEntry));
    } on BackupFormatException {
      rethrow;
    } catch (_) {
      throw const BackupFormatException('The settings in that backup are damaged.');
    }

    final Object? decodedHistory;
    try {
      decodedHistory = jsonDecode(historyRaw);
    } catch (_) {
      throw const BackupFormatException('The history in that backup is not valid JSON.');
    }
    if (decodedHistory is! List) {
      throw const BackupFormatException('The history in that backup is not a list.');
    }

    final history = <WorkoutRecord>[];
    for (final entry in decodedHistory) {
      if (entry is! Map) continue;
      try {
        history.add(WorkoutRecord.fromJson(entry.cast<String, Object?>()));
      } catch (_) {
        // Skip an individual damaged row rather than losing the whole backup.
      }
    }

    return BackupContents(
      settings: settings,
      history: history,
      exportedAt: DateTime.tryParse(manifest['exportedAt'] as String? ?? ''),
      appVersion: manifest['appVersion'] as String?,
    );
  }

  static String? _entryText(Archive archive, String name) {
    final file = archive.find(name);
    if (file == null) return null;
    try {
      return utf8.decode(file.readBytes() ?? const <int>[]);
    } catch (_) {
      throw BackupFormatException('$name in that backup is not valid UTF-8.');
    }
  }

  static Map<String, Object?> _asObject(String raw, String name) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      throw BackupFormatException('$name in that backup is not valid JSON.');
    }
    if (decoded is! Map) {
      throw BackupFormatException('$name in that backup is not a JSON object.');
    }
    return decoded.cast<String, Object?>();
  }
}
