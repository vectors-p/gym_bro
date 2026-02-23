// rename imageUrl back to gifUrl to stay consistent with Exercise entity
import 'package:equatable/equatable.dart';

class WorkoutExercise extends Equatable {
  final String exerciseId;
  final String exerciseName;
  final String gifUrl; // ✅ back to gifUrl
  final String targetMuscle;
  final int sets;
  final int reps;
  final int restSeconds;

  const WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.gifUrl, // ✅
    required this.targetMuscle,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });

  WorkoutExercise copyWith({int? sets, int? reps, int? restSeconds}) {
    return WorkoutExercise(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      gifUrl: gifUrl,
      targetMuscle: targetMuscle,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  @override
  List<Object?> get props => [
    exerciseId,
    exerciseName,
    gifUrl,
    targetMuscle,
    sets,
    reps,
    restSeconds,
  ];
}
