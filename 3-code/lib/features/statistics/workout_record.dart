class WorkoutRecord {
  const WorkoutRecord({
    required this.completedAt,
    required this.durationSeconds,
    required this.workoutUnits,
    required this.restSeconds,
    required this.sets,
    required this.frequencySeconds,
    required this.completed,
  });

  final DateTime completedAt;
  final int durationSeconds;
  final int workoutUnits;
  final int restSeconds;
  final int sets;
  final double frequencySeconds;
  final bool completed;

  Map<String, Object> toJson() {
    return <String, Object>{
      'completedAt': completedAt.toIso8601String(),
      'durationSeconds': durationSeconds,
      'workoutUnits': workoutUnits,
      'restSeconds': restSeconds,
      'sets': sets,
      'frequencySeconds': frequencySeconds,
      'completed': completed,
    };
  }

  factory WorkoutRecord.fromJson(Map<String, Object?> json) {
    return WorkoutRecord(
      completedAt: DateTime.parse(json['completedAt']! as String),
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      workoutUnits: json['workoutUnits'] as int? ?? 0,
      restSeconds: json['restSeconds'] as int? ?? 0,
      sets: json['sets'] as int? ?? 0,
      frequencySeconds: (json['frequencySeconds'] as num?)?.toDouble() ?? 1.0,
      completed: json['completed'] as bool? ?? false,
    );
  }
}
