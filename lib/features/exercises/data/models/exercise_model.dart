import '../../domain/entities/exercise.dart';

class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.gifUrl,
    required super.bodyParts,
    required super.equipments,
    required super.targetMuscles,
    required super.secondaryMuscles,
    required super.instructions,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['exerciseId'] as String,
      name: json['name'] as String,
      gifUrl: json['gifUrl'] as String? ?? '',
      bodyParts: List<String>.from(json['bodyParts'] ?? []),
      equipments: List<String>.from(json['equipments'] ?? []),
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'exerciseId': id,
    'name': name,
    'gifUrl': gifUrl,
    'bodyParts': bodyParts,
    'equipments': equipments,
    'targetMuscles': targetMuscles,
    'secondaryMuscles': secondaryMuscles,
    'instructions': instructions,
  };
}
