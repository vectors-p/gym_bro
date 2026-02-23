import 'package:equatable/equatable.dart';
import '../../../exercises/domain/entities/exercise.dart';

abstract class EquipmentState extends Equatable {
  const EquipmentState();

  @override
  List<Object?> get props => [];
}

class EquipmentInitial extends EquipmentState {}

class EquipmentLoading extends EquipmentState {}

class EquipmentListLoaded extends EquipmentState {
  final List<String> equipmentList;
  const EquipmentListLoaded(this.equipmentList);

  @override
  List<Object?> get props => [equipmentList];
}

class EquipmentExercisesLoaded extends EquipmentState {
  final String equipment;
  final List<Exercise> exercises;

  const EquipmentExercisesLoaded({
    required this.equipment,
    required this.exercises,
  });

  @override
  List<Object?> get props => [equipment, exercises];
}

class EquipmentError extends EquipmentState {
  final String message;
  const EquipmentError(this.message);

  @override
  List<Object?> get props => [message];
}
