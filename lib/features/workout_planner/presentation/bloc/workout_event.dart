import 'package:equatable/equatable.dart';
import '../../domain/entities/workout_exercise.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllWorkouts extends WorkoutEvent {
  const LoadAllWorkouts();
}

class LoadWorkoutById extends WorkoutEvent {
  final String workoutId;
  const LoadWorkoutById(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

class CreateWorkout extends WorkoutEvent {
  final String name;
  final String description;

  const CreateWorkout({required this.name, required this.description});

  @override
  List<Object?> get props => [name, description];
}

class AddExerciseToWorkout extends WorkoutEvent {
  final String workoutId;
  final WorkoutExercise exercise;

  const AddExerciseToWorkout({required this.workoutId, required this.exercise});

  @override
  List<Object?> get props => [workoutId, exercise];
}

class RemoveExerciseFromWorkout extends WorkoutEvent {
  final String workoutId;
  final String exerciseId;

  const RemoveExerciseFromWorkout({
    required this.workoutId,
    required this.exerciseId,
  });

  @override
  List<Object?> get props => [workoutId, exerciseId];
}

class UpdateExerciseInWorkout extends WorkoutEvent {
  final String workoutId;
  final WorkoutExercise exercise;

  const UpdateExerciseInWorkout({
    required this.workoutId,
    required this.exercise,
  });

  @override
  List<Object?> get props => [workoutId, exercise];
}

class DeleteWorkout extends WorkoutEvent {
  final String workoutId;
  const DeleteWorkout(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}
