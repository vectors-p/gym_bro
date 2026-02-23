import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/injection_container.dart';
import '../bloc/target_muscle_bloc.dart';
import '../bloc/target_muscle_event.dart';
import '../bloc/target_muscle_state.dart';
import '../../../exercises/presentation/widgets/exercise_card.dart';

class TargetMuscleExercisesPage extends StatelessWidget {
  final String muscle;

  const TargetMuscleExercisesPage({super.key, required this.muscle});

  @override
  Widget build(BuildContext context) {
    final display = muscle[0].toUpperCase() + muscle.substring(1);

    return BlocProvider(
      create: (_) => sl<TargetMuscleBloc>()..add(LoadExercisesByTarget(muscle)),
      child: Scaffold(
        appBar: AppBar(title: Text(display)),
        body: BlocBuilder<TargetMuscleBloc, TargetMuscleState>(
          builder: (context, state) {
            if (state is TargetMuscleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TargetMuscleExercisesLoaded) {
              if (state.exercises.isEmpty) {
                return const Center(child: Text('No exercises found.'));
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
            if (state is TargetMuscleError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
