import 'package:equatable/equatable.dart';

abstract class EquipmentEvent extends Equatable {
  const EquipmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadEquipmentList extends EquipmentEvent {
  const LoadEquipmentList();
}

class LoadExercisesByEquipment extends EquipmentEvent {
  final String equipment;
  final int limit;
  final int offset;

  const LoadExercisesByEquipment(
    this.equipment, {
    this.limit = 20,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [equipment, limit, offset];
}
