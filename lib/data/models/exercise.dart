class Exercise {
  final String id;
  final String name;
  final String description;
  final String category; // 'strength', 'cardio', 'flexibility', 'balance'
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final String
      equipment; // 'bodyweight', 'dumbbells', 'barbell', 'machine', 'none'
  final String
      muscleGroups; // 'chest', 'back', 'legs', 'arms', 'core', 'full body'
  final int? duration; // in seconds for timed exercises
  final int? reps; // for rep-based exercises
  final int? sets; // number of sets
  final String? instructions; // detailed instructions
  final String? videoUrl; // demonstration video
  final String? imageUrl; // exercise image
  final Map<String, dynamic> variations; // alternative versions
  final List<String> tips; // helpful tips
  final bool isCustom; // whether it's a custom exercise created by coach

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.equipment,
    required this.muscleGroups,
    this.duration,
    this.reps,
    this.sets,
    this.instructions,
    this.videoUrl,
    this.imageUrl,
    this.variations = const {},
    this.tips = const [],
    this.isCustom = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'strength',
      difficulty: json['difficulty'] ?? 'beginner',
      equipment: json['equipment'] ?? 'bodyweight',
      muscleGroups: json['muscleGroups'] ?? '',
      duration: json['duration'],
      reps: json['reps'],
      sets: json['sets'],
      instructions: json['instructions'],
      videoUrl: json['videoUrl'],
      imageUrl: json['imageUrl'],
      variations: Map<String, dynamic>.from(json['variations'] ?? {}),
      tips: List<String>.from(json['tips'] ?? []),
      isCustom: json['isCustom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'equipment': equipment,
      'muscleGroups': muscleGroups,
      'duration': duration,
      'reps': reps,
      'sets': sets,
      'instructions': instructions,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'variations': variations,
      'tips': tips,
      'isCustom': isCustom,
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? difficulty,
    String? equipment,
    String? muscleGroups,
    int? duration,
    int? reps,
    int? sets,
    String? instructions,
    String? videoUrl,
    String? imageUrl,
    Map<String, dynamic>? variations,
    List<String>? tips,
    bool? isCustom,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      equipment: equipment ?? this.equipment,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      duration: duration ?? this.duration,
      reps: reps ?? this.reps,
      sets: sets ?? this.sets,
      instructions: instructions ?? this.instructions,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      variations: variations ?? this.variations,
      tips: tips ?? this.tips,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  // Helper getters
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'strength':
        return '💪';
      case 'cardio':
        return '❤️';
      case 'flexibility':
        return '🤸';
      case 'balance':
        return '⚖️';
      default:
        return '🏃';
    }
  }

  String get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'green';
      case 'intermediate':
        return 'orange';
      case 'advanced':
        return 'red';
      default:
        return 'grey';
    }
  }

  String get equipmentIcon {
    switch (equipment.toLowerCase()) {
      case 'bodyweight':
        return '🏃';
      case 'dumbbells':
        return '🏋️';
      case 'barbell':
        return '🏋️‍♂️';
      case 'machine':
        return '🏋️‍♀️';
      case 'none':
        return '🤸';
      default:
        return '🏃';
    }
  }

  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  String get formattedReps {
    if (reps == null) return '';
    return '$reps reps';
  }

  String get formattedSets {
    if (sets == null) return '';
    return '$sets sets';
  }
}

class ExerciseSet {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final int? reps;
  final int? duration; // in seconds
  final double? weight; // in kg
  final int? restTime; // in seconds
  final String? notes;
  final int order; // order in the workout

  ExerciseSet({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    this.reps,
    this.duration,
    this.weight,
    this.restTime,
    this.notes,
    required this.order,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      id: json['id'] ?? '',
      exerciseId: json['exerciseId'] ?? '',
      exerciseName: json['exerciseName'] ?? '',
      reps: json['reps'],
      duration: json['duration'],
      weight: json['weight']?.toDouble(),
      restTime: json['restTime'],
      notes: json['notes'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'reps': reps,
      'duration': duration,
      'weight': weight,
      'restTime': restTime,
      'notes': notes,
      'order': order,
    };
  }

  ExerciseSet copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    int? reps,
    int? duration,
    double? weight,
    int? restTime,
    String? notes,
    int? order,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      weight: weight ?? this.weight,
      restTime: restTime ?? this.restTime,
      notes: notes ?? this.notes,
      order: order ?? this.order,
    );
  }
}

class WorkoutTemplate {
  final String id;
  final String name;
  final String description;
  final String category; // 'strength', 'cardio', 'hiit', 'yoga', 'pilates'
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final int duration; // in minutes
  final List<ExerciseSet> exercises;
  final String? imageUrl;
  final bool isCustom;
  final String? createdBy; // coach ID who created it

  WorkoutTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.exercises,
    this.imageUrl,
    this.isCustom = false,
    this.createdBy,
  });

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) {
    return WorkoutTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'strength',
      difficulty: json['difficulty'] ?? 'beginner',
      duration: json['duration'] ?? 30,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((exercise) => ExerciseSet.fromJson(exercise))
              .toList() ??
          [],
      imageUrl: json['imageUrl'],
      isCustom: json['isCustom'] ?? false,
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'duration': duration,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'imageUrl': imageUrl,
      'isCustom': isCustom,
      'createdBy': createdBy,
    };
  }

  WorkoutTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? difficulty,
    int? duration,
    List<ExerciseSet>? exercises,
    String? imageUrl,
    bool? isCustom,
    String? createdBy,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      exercises: exercises ?? this.exercises,
      imageUrl: imageUrl ?? this.imageUrl,
      isCustom: isCustom ?? this.isCustom,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'strength':
        return '💪';
      case 'cardio':
        return '❤️';
      case 'hiit':
        return '🔥';
      case 'yoga':
        return '🧘';
      case 'pilates':
        return '🤸';
      default:
        return '🏃';
    }
  }

  String get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'green';
      case 'intermediate':
        return 'orange';
      case 'advanced':
        return 'red';
      default:
        return 'grey';
    }
  }
}
