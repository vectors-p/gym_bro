import 'package:equatable/equatable.dart';

abstract class BodyPartEvent extends Equatable {
  const BodyPartEvent();

  @override
  List<Object?> get props => [];
}

class LoadBodyPartList extends BodyPartEvent {
  const LoadBodyPartList();
}

class LoadExercisesByBodyPart extends BodyPartEvent {
  final String bodyPart;
  final int limit;
  final int offset;

  const LoadExercisesByBodyPart(
    this.bodyPart, {
    this.limit = 20,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [bodyPart, limit, offset];
}
