import '../../domain/entities/workout_exercise.dart';

class WorkoutExerciseModel extends WorkoutExercise {
  const WorkoutExerciseModel({
    required super.exerciseId,
    required super.exerciseName,
    required super.gifUrl,
    required super.targetMuscle,
    required super.sets,
    required super.reps,
    super.weight,
  });

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      gifUrl: json['gifUrl'] as String,
      targetMuscle: json['targetMuscle'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'exerciseName': exerciseName,
    'gifUrl': gifUrl,
    'targetMuscle': targetMuscle,
    'sets': sets,
    'reps': reps,
    'weight': weight,
  };

  factory WorkoutExerciseModel.fromEntity(WorkoutExercise entity) {
    return WorkoutExerciseModel(
      exerciseId: entity.exerciseId,
      exerciseName: entity.exerciseName,
      gifUrl: entity.gifUrl,
      targetMuscle: entity.targetMuscle,
      sets: entity.sets,
      reps: entity.reps,
      weight: entity.weight,
    );
  }
}
