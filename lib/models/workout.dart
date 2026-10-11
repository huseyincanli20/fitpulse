import 'exercise.dart';

class WorkoutPlan {
  final String id;
  final String title;
  final String subtitle;
  final String category; // Güç, Hipertrofi, Yağ Yakımı, vb.
  final int estimatedMinutes;
  final int estimatedCalories;
  final String difficulty; // Başlangıç, Orta, İleri
  final List<Exercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.estimatedMinutes,
    required this.estimatedCalories,
    required this.difficulty,
    required this.exercises,
  });
}

class CompletedWorkout {
  final String id;
  final String title;
  final DateTime date;
  final int durationSeconds;
  final int totalCalories;
  final double totalVolumeKg;
  final int completedSetsCount;

  CompletedWorkout({
    required this.id,
    required this.title,
    required this.date,
    required this.durationSeconds,
    required this.totalCalories,
    required this.totalVolumeKg,
    required this.completedSetsCount,
  });
}
