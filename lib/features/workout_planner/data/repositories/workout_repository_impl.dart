import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart'; // add uuid: ^4.5.0 to pubspec
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';
import '../../domain/repositories/workout_repository.dart';
import '../data_providers/workout_local_provider.dart';
import '../models/workout_exercise_model.dart';
import '../models/workout_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalProvider _localProvider;
  final _uuid = const Uuid();

  WorkoutRepositoryImpl({required WorkoutLocalProvider localProvider})
    : _localProvider = localProvider;

  @override
  Future<Either<Failure, List<Workout>>> getAllWorkouts() async {
    try {
      final workouts = await _localProvider.getAllWorkouts();
      return Right(workouts);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Workout>> getWorkoutById(String id) async {
    try {
      final workout = await _localProvider.getWorkoutById(id);
      if (workout == null) {
        return Left(CacheFailure(message: 'Workout not found'));
      }
      return Right(workout);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Workout>> createWorkout({
    required String name,
    required String description,
  }) async {
    try {
      final workouts = await _localProvider.getAllWorkouts();
      final newWorkout = WorkoutModel(
        id: _uuid.v4(),
        name: name,
        description: description,
        exercises: [],
        createdAt: DateTime.now(),
      );
      workouts.add(newWorkout);
      await _localProvider.saveWorkouts(workouts);
      return Right(newWorkout);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Workout>> addExerciseToWorkout({
    required String workoutId,
    required WorkoutExercise exercise,
  }) async {
    try {
      final workouts = await _localProvider.getAllWorkouts();
      final index = workouts.indexWhere((w) => w.id == workoutId);
      if (index == -1) {
        return Left(CacheFailure(message: 'Workout not found'));
      }

      final updatedExercises = [
        ...workouts[index].exercises,
        WorkoutExerciseModel.fromEntity(exercise),
      ];
      final updated = WorkoutModel(
        id: workouts[index].id,
        name: workouts[index].name,
        description: workouts[index].description,
        exercises: updatedExercises,
        createdAt: workouts[index].createdAt,
      );
      workouts[index] = updated;
      await _localProvider.saveWorkouts(workouts);
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Workout>> removeExerciseFromWorkout({
    required String workoutId,
    required String exerciseId,
  }) async {
    try {
      final workouts = await _localProvider.getAllWorkouts();
      final index = workouts.indexWhere((w) => w.id == workoutId);
      if (index == -1) {
        return Left(CacheFailure(message: 'Workout not found'));
      }

      final updatedExercises = workouts[index].exercises
          .where((e) => e.exerciseId != exerciseId)
          .toList();
      final updated = WorkoutModel(
        id: workouts[index].id,
        name: workouts[index].name,
        description: workouts[index].description,
        exercises: updatedExercises,
        createdAt: workouts[index].createdAt,
      );
      workouts[index] = updated;
      await _localProvider.saveWorkouts(workouts);
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Workout>> updateExerciseInWorkout({
    required String workoutId,
    required WorkoutExercise exercise,
  }) async {
    try {
      final workouts = await _localProvider.getAllWorkouts();
      final wIndex = workouts.indexWhere((w) => w.id == workoutId);
      if (wIndex == -1) {
        return Left(CacheFailure(message: 'Workout not found'));
      }

      final updatedExercises = workouts[wIndex].exercises.map((e) {
        return e.exerciseId == exercise.exerciseId
            ? WorkoutExerciseModel.fromEntity(exercise)
            : e;
      }).toList();

      final updated = WorkoutModel(
        id: workouts[wIndex].id,
        name: workouts[wIndex].name,
        description: workouts[wIndex].description,
        exercises: updatedExercises,
        createdAt: workouts[wIndex].createdAt,
      );
      workouts[wIndex] = updated;
      await _localProvider.saveWorkouts(workouts);
      return Right(updated);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteWorkout(String id) async {
    try {
      final workouts = await _localProvider.getAllWorkouts();
      workouts.removeWhere((w) => w.id == id);
      await _localProvider.saveWorkouts(workouts);
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
