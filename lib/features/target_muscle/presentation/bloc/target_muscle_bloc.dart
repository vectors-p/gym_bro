import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/target_muscle_repository.dart';
import 'target_muscle_event.dart';
import 'target_muscle_state.dart';

class TargetMuscleBloc extends Bloc<TargetMuscleEvent, TargetMuscleState> {
  final TargetMuscleRepository _repository;

  TargetMuscleBloc({required TargetMuscleRepository repository})
    : _repository = repository,
      super(TargetMuscleInitial()) {
    on<LoadTargetMuscleList>(_onLoadList);
    on<LoadExercisesByTarget>(_onLoadExercises);
  }

  Future<void> _onLoadList(
    LoadTargetMuscleList event,
    Emitter<TargetMuscleState> emit,
  ) async {
    emit(TargetMuscleLoading());
    final result = await _repository.getTargetMuscleList();
    result.fold(
      (failure) => emit(TargetMuscleError(failure.message)),
      (muscles) => emit(TargetMuscleListLoaded(muscles)),
    );
  }

  Future<void> _onLoadExercises(
    LoadExercisesByTarget event,
    Emitter<TargetMuscleState> emit,
  ) async {
    emit(TargetMuscleLoading());
    final result = await _repository.getExercisesByTarget(
      event.muscle,
      limit: event.limit,
      offset: event.offset,
    );
    result.fold(
      (failure) => emit(TargetMuscleError(failure.message)),
      (exercises) => emit(
        TargetMuscleExercisesLoaded(muscle: event.muscle, exercises: exercises),
      ),
    );
  }
}
