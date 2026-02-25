import 'package:equatable/equatable.dart';
import 'workout_exercise.dart';

class Workout extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<WorkoutExercise> exercises;
  final DateTime createdAt;

  const Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
    required this.createdAt,
  });

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);

  int get estimatedMinutes =>
      exercises.fold(0, (sum, e) => sum + (e.sets * (e.reps * 3 + 60))) ~/ 60;

  Workout copyWith({
    String? name,
    String? description,
    List<WorkoutExercise>? exercises,
  }) {
    return Workout(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, exercises, createdAt];
}
