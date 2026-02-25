import 'package:equatable/equatable.dart';

class WorkoutExercise extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final String gifUrl;
  final String targetMuscle;
  final int sets;
  final int reps;
  final double? weight; // nullable — bodyweight exercises have no weight

  const WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.gifUrl,
    required this.targetMuscle,
    required this.sets,
    required this.reps,
    this.weight,
  });

  WorkoutExercise copyWith({
    int? sets,
    int? reps,
    double? weight,
    bool clearWeight = false,
  }) {
    return WorkoutExercise(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      gifUrl: gifUrl,
      targetMuscle: targetMuscle,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: clearWeight ? null : (weight ?? this.weight),
    );
  }

  String get weightDisplay => weight != null
      ? '${weight!.toStringAsFixed(weight! % 1 == 0 ? 0 : 1)} kg'
      : 'Bodyweight';

  @override
  List<Object?> get props => [
    exerciseId,
    exerciseName,
    gifUrl,
    targetMuscle,
    sets,
    reps,
    weight,
  ];
}
