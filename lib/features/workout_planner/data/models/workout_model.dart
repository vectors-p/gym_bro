import '../../domain/entities/workout.dart';
import 'workout_exercise_model.dart';

class WorkoutModel extends Workout {
  const WorkoutModel({
    required super.id,
    required super.name,
    required super.description,
    required super.exercises,
    required super.createdAt,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'exercises': exercises
        .map((e) => WorkoutExerciseModel.fromEntity(e).toJson())
        .toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory WorkoutModel.fromEntity(Workout entity) {
    return WorkoutModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      exercises: entity.exercises,
      createdAt: entity.createdAt,
    );
  }
}
