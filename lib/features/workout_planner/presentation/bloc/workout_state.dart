import 'package:equatable/equatable.dart';
import '../../domain/entities/workout.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutsLoaded extends WorkoutState {
  final List<Workout> workouts;
  const WorkoutsLoaded(this.workouts);

  @override
  List<Object?> get props => [workouts];
}

class WorkoutDetailLoaded extends WorkoutState {
  final Workout workout;
  const WorkoutDetailLoaded(this.workout);

  @override
  List<Object?> get props => [workout];
}

class WorkoutOperationSuccess extends WorkoutState {
  final Workout workout;
  final String message;

  const WorkoutOperationSuccess({required this.workout, required this.message});

  @override
  List<Object?> get props => [workout, message];
}

class WorkoutDeleted extends WorkoutState {}

class WorkoutError extends WorkoutState {
  final String message;
  const WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}
