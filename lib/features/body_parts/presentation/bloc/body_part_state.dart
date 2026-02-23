import 'package:equatable/equatable.dart';
import '../../../exercises/domain/entities/exercise.dart';

abstract class BodyPartState extends Equatable {
  const BodyPartState();

  @override
  List<Object?> get props => [];
}

class BodyPartInitial extends BodyPartState {}

class BodyPartLoading extends BodyPartState {}

class BodyPartListLoaded extends BodyPartState {
  final List<String> bodyParts;
  const BodyPartListLoaded(this.bodyParts);

  @override
  List<Object?> get props => [bodyParts];
}

class BodyPartExercisesLoaded extends BodyPartState {
  final String bodyPart;
  final List<Exercise> exercises;

  const BodyPartExercisesLoaded({
    required this.bodyPart,
    required this.exercises,
  });

  @override
  List<Object?> get props => [bodyPart, exercises];
}

class BodyPartError extends BodyPartState {
  final String message;
  const BodyPartError(this.message);

  @override
  List<Object?> get props => [message];
}
