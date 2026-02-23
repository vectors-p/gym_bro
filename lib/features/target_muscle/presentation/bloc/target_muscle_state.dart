import 'package:equatable/equatable.dart';
import '../../../exercises/domain/entities/exercise.dart';

abstract class TargetMuscleState extends Equatable {
  const TargetMuscleState();

  @override
  List<Object?> get props => [];
}

class TargetMuscleInitial extends TargetMuscleState {}

class TargetMuscleLoading extends TargetMuscleState {}

class TargetMuscleListLoaded extends TargetMuscleState {
  final List<String> muscles;
  const TargetMuscleListLoaded(this.muscles);

  @override
  List<Object?> get props => [muscles];
}

class TargetMuscleExercisesLoaded extends TargetMuscleState {
  final String muscle;
  final List<Exercise> exercises;

  const TargetMuscleExercisesLoaded({
    required this.muscle,
    required this.exercises,
  });

  @override
  List<Object?> get props => [muscle, exercises];
}

class TargetMuscleError extends TargetMuscleState {
  final String message;
  const TargetMuscleError(this.message);

  @override
  List<Object?> get props => [message];
}
