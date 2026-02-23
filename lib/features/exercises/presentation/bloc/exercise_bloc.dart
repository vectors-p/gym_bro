import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_bro/features/exercises/domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository _repository;
  static const int _pageSize = 20;

  ExerciseBloc({required ExerciseRepository repository})
    : _repository = repository,
      super(ExerciseInitial()) {
    on<LoadAllExercises>(_onLoadAll);
    on<LoadMoreExercises>(_onLoadMore);
    on<LoadExerciseById>(_onLoadById);
  }

  Future<void> _onLoadAll(
    LoadAllExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await _repository.getAllExercises(
      limit: event.limit,
      offset: event.offset,
    );
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (exercises) => emit(
        ExercisesLoaded(
          exercises: exercises,
          hasMore: exercises.length >= _pageSize,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    // Keep the current list visible while loading more
    final current = state is ExercisesLoaded
        ? (state as ExercisesLoaded).exercises
        : <Exercise>[];

    emit(ExerciseLoadingMore(current));

    final result = await _repository.getAllExercises(
      limit: event.limit,
      offset: event.offset,
    );
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (newExercises) => emit(
        ExercisesLoaded(
          exercises: [...current, ...newExercises],
          hasMore: newExercises.length >= _pageSize,
        ),
      ),
    );
  }

  Future<void> _onLoadById(
    LoadExerciseById event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await _repository.getExerciseById(event.id);
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (exercise) => emit(ExerciseDetailLoaded(exercise)),
    );
  }
}
