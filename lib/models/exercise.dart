class WorkoutSet {
  int setNumber;
  int reps;
  double weightKg;
  bool isCompleted;

  WorkoutSet({
    required this.setNumber,
    required this.reps,
    required this.weightKg,
    this.isCompleted = false,
  });

  WorkoutSet copyWith({
    int? setNumber,
    int? reps,
    double? weightKg,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String category; // Göğüs, Sırt, Bacak, vb.
  final String targetMuscle;
  final String equipment;
  final String description;
  final int defaultSets;
  final int defaultReps;
  final double defaultWeightKg;
  final String iconName;
  final String videoUrl;
  final String thumbnailUrl;
  final List<String> executionSteps;
  final List<String> commonMistakes;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.targetMuscle,
    required this.equipment,
    required this.description,
    this.defaultSets = 4,
    this.defaultReps = 10,
    this.defaultWeightKg = 40.0,
    this.iconName = 'fitness_center',
    this.videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    this.thumbnailUrl = '',
    this.executionSteps = const [],
    this.commonMistakes = const [],
  });
}
