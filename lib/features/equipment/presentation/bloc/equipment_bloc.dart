import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/equipment_repository.dart';
import 'equipment_event.dart';
import 'equipment_state.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  final EquipmentRepository _repository;

  EquipmentBloc({required EquipmentRepository repository})
    : _repository = repository,
      super(EquipmentInitial()) {
    on<LoadEquipmentList>(_onLoadEquipmentList);
    on<LoadExercisesByEquipment>(_onLoadExercisesByEquipment);
  }

  Future<void> _onLoadEquipmentList(
    LoadEquipmentList event,
    Emitter<EquipmentState> emit,
  ) async {
    emit(EquipmentLoading());
    final result = await _repository.getEquipmentList();
    result.fold(
      (failure) => emit(EquipmentError(failure.message)),
      (list) => emit(EquipmentListLoaded(list)),
    );
  }

  Future<void> _onLoadExercisesByEquipment(
    LoadExercisesByEquipment event,
    Emitter<EquipmentState> emit,
  ) async {
    emit(EquipmentLoading());
    final result = await _repository.getExercisesByEquipment(
      event.equipment,
      limit: event.limit,
      offset: event.offset,
    );
    result.fold(
      (failure) => emit(EquipmentError(failure.message)),
      (exercises) => emit(
        EquipmentExercisesLoaded(
          equipment: event.equipment,
          exercises: exercises,
        ),
      ),
    );
  }
}
