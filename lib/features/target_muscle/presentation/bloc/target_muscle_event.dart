import 'package:equatable/equatable.dart';

abstract class TargetMuscleEvent extends Equatable {
  const TargetMuscleEvent();

  @override
  List<Object?> get props => [];
}

class LoadTargetMuscleList extends TargetMuscleEvent {
  const LoadTargetMuscleList();
}

class LoadExercisesByTarget extends TargetMuscleEvent {
  final String muscle;
  final int limit;
  final int offset;

  const LoadExercisesByTarget(this.muscle, {this.limit = 20, this.offset = 0});

  @override
  List<Object?> get props => [muscle, limit, offset];
}
