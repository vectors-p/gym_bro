import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/body_part_repository.dart';
import 'body_part_event.dart';
import 'body_part_state.dart';

class BodyPartBloc extends Bloc<BodyPartEvent, BodyPartState> {
  final BodyPartRepository _repository;

  BodyPartBloc({required BodyPartRepository repository})
    : _repository = repository,
      super(BodyPartInitial()) {
    on<LoadBodyPartList>(_onLoadBodyPartList);
    on<LoadExercisesByBodyPart>(_onLoadExercisesByBodyPart);
  }

  Future<void> _onLoadBodyPartList(
    LoadBodyPartList event,
    Emitter<BodyPartState> emit,
  ) async {
    emit(BodyPartLoading());
    final result = await _repository.getBodyPartList();
    result.fold(
      (failure) => emit(BodyPartError(failure.message)),
      (bodyParts) => emit(BodyPartListLoaded(bodyParts)),
    );
  }

  Future<void> _onLoadExercisesByBodyPart(
    LoadExercisesByBodyPart event,
    Emitter<BodyPartState> emit,
  ) async {
    emit(BodyPartLoading());
    final result = await _repository.getExercisesByBodyPart(
      event.bodyPart,
      limit: event.limit,
      offset: event.offset,
    );
    result.fold(
      (failure) => emit(BodyPartError(failure.message)),
      (exercises) => emit(
        BodyPartExercisesLoaded(bodyPart: event.bodyPart, exercises: exercises),
      ),
    );
  }
}
