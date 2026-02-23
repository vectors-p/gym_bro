import 'package:equatable/equatable.dart';
import '../../domain/entities/exercise.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

// Separate loading state for pagination — keeps existing list visible
class ExerciseLoadingMore extends ExerciseState {
  final List<Exercise> currentExercises;

  const ExerciseLoadingMore(this.currentExercises);

  @override
  List<Object?> get props => [currentExercises];
}

class ExercisesLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final bool hasMore; // false when API returns fewer than the page limit

  const ExercisesLoaded({required this.exercises, this.hasMore = true});

  @override
  List<Object?> get props => [exercises, hasMore];
}

class ExerciseDetailLoaded extends ExerciseState {
  final Exercise exercise;

  const ExerciseDetailLoaded(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}
