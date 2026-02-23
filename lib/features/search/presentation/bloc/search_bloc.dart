import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../exercises/domain/repositories/exercise_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ExerciseRepository _repository;

  SearchBloc({required ExerciseRepository repository})
    : _repository = repository,
      super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchCleared>(_onCleared);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await _repository.searchExercisesByName(query);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (exercises) => exercises.isEmpty
          ? emit(SearchEmpty(query))
          : emit(SearchLoaded(results: exercises, query: query)),
    );
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
