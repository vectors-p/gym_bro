import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String gifUrl; // ✅ back — full URL provided by API
  final List<String> bodyParts; // array
  final List<String> equipments; // array
  final List<String> targetMuscles; // array
  final List<String> secondaryMuscles;
  final List<String> instructions; // ✅ back — list of strings

  const Exercise({
    required this.id,
    required this.name,
    required this.gifUrl,
    required this.bodyParts,
    required this.equipments,
    required this.targetMuscles,
    required this.secondaryMuscles,
    required this.instructions,
  });

  // Convenience getters for UI that expects a single string
  String get primaryBodyPart => bodyParts.isNotEmpty ? bodyParts.first : '';
  String get primaryEquipment => equipments.isNotEmpty ? equipments.first : '';
  String get primaryTarget =>
      targetMuscles.isNotEmpty ? targetMuscles.first : '';

  @override
  List<Object?> get props => [
    id,
    name,
    gifUrl,
    bodyParts,
    equipments,
    targetMuscles,
    secondaryMuscles,
    instructions,
  ];
}
