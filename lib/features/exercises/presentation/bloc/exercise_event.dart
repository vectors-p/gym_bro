import 'package:equatable/equatable.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllExercises extends ExerciseEvent {
  final int limit;
  final int offset;

  const LoadAllExercises({this.limit = 20, this.offset = 0});

  @override
  List<Object?> get props => [limit, offset];
}

class LoadMoreExercises extends ExerciseEvent {
  final int limit;
  final int offset;

  const LoadMoreExercises({required this.limit, required this.offset});

  @override
  List<Object?> get props => [limit, offset];
}

class LoadExerciseById extends ExerciseEvent {
  final String id;

  const LoadExerciseById(this.id);

  @override
  List<Object?> get props => [id];
}
