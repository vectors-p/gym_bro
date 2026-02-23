import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/workout_repository.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository _repository;

  WorkoutBloc({required WorkoutRepository repository})
    : _repository = repository,
      super(WorkoutInitial()) {
    on<LoadAllWorkouts>(_onLoadAll);
    on<LoadWorkoutById>(_onLoadById);
    on<CreateWorkout>(_onCreate);
    on<AddExerciseToWorkout>(_onAddExercise);
    on<RemoveExerciseFromWorkout>(_onRemoveExercise);
    on<UpdateExerciseInWorkout>(_onUpdateExercise);
    on<DeleteWorkout>(_onDelete);
  }

  Future<void> _onLoadAll(
    LoadAllWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await _repository.getAllWorkouts();
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutsLoaded(workouts)),
    );
  }

  Future<void> _onLoadById(
    LoadWorkoutById event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await _repository.getWorkoutById(event.workoutId);
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(WorkoutDetailLoaded(workout)),
    );
  }

  Future<void> _onCreate(
    CreateWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await _repository.createWorkout(
      name: event.name,
      description: event.description,
    );
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(
        WorkoutOperationSuccess(workout: workout, message: 'Workout created!'),
      ),
    );
  }

  Future<void> _onAddExercise(
    AddExerciseToWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    final result = await _repository.addExerciseToWorkout(
      workoutId: event.workoutId,
      exercise: event.exercise,
    );
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(WorkoutDetailLoaded(workout)),
    );
  }

  Future<void> _onRemoveExercise(
    RemoveExerciseFromWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    final result = await _repository.removeExerciseFromWorkout(
      workoutId: event.workoutId,
      exerciseId: event.exerciseId,
    );
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(WorkoutDetailLoaded(workout)),
    );
  }

  Future<void> _onUpdateExercise(
    UpdateExerciseInWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    final result = await _repository.updateExerciseInWorkout(
      workoutId: event.workoutId,
      exercise: event.exercise,
    );
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(WorkoutDetailLoaded(workout)),
    );
  }

  Future<void> _onDelete(
    DeleteWorkout event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await _repository.deleteWorkout(event.workoutId);
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (_) => emit(WorkoutDeleted()),
    );
  }
}
