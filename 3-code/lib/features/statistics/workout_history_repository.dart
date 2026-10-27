import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'workout_record.dart';

class WorkoutHistoryRepository {
  static const String _historyKey = 'workout_history_json';

  Future<List<WorkoutRecord>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) {
      return <WorkoutRecord>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => WorkoutRecord.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<WorkoutRecord> items) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = items.map((item) => item.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(payload));
  }
}
