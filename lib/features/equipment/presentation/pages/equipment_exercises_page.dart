import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/core/di/injection_container.dart';
import 'package:gym_bro/features/equipment/presentation/bloc/equipment_bloc.dart';
import 'package:gym_bro/features/equipment/presentation/bloc/equipment_event.dart';
import 'package:gym_bro/features/equipment/presentation/bloc/equipment_state.dart';
import 'package:gym_bro/features/exercises/presentation/widgets/exercise_card.dart';

class EquipmentExercisesPage extends StatelessWidget {
  final String equipmentType;

  const EquipmentExercisesPage({super.key, required this.equipmentType});

  @override
  Widget build(BuildContext context) {
    final display = equipmentType[0].toUpperCase() + equipmentType.substring(1);

    return BlocProvider(
      create: (_) =>
          sl<EquipmentBloc>()..add(LoadExercisesByEquipment(equipmentType)),
      child: Scaffold(
        appBar: AppBar(title: Text(display)),
        body: BlocBuilder<EquipmentBloc, EquipmentState>(
          builder: (context, state) {
            if (state is EquipmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is EquipmentExercisesLoaded) {
              if (state.exercises.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No exercises found for $equipmentType',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = state.exercises[index];
                  return ExerciseCard(
                    exercise: exercise,
                    onTap: () => context.push(
                      '/exercises/${exercise.id}',
                      extra: exercise,
                    ),
                  );
                },
              );
            }
            if (state is EquipmentError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
