import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/workout.dart';
import '../entities/workout_exercise.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, List<Workout>>> getAllWorkouts();
  Future<Either<Failure, Workout>> getWorkoutById(String id);
  Future<Either<Failure, Workout>> createWorkout({
    required String name,
    required String description,
  });
  Future<Either<Failure, Workout>> addExerciseToWorkout({
    required String workoutId,
    required WorkoutExercise exercise,
  });
  Future<Either<Failure, Workout>> removeExerciseFromWorkout({
    required String workoutId,
    required String exerciseId,
  });
  Future<Either<Failure, Workout>> updateExerciseInWorkout({
    required String workoutId,
    required WorkoutExercise exercise,
  });
  Future<Either<Failure, bool>> deleteWorkout(String id);
}
