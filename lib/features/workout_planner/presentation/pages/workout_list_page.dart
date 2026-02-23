import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';
import '../widgets/workout_card.dart';

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({super.key});

  @override
  State<WorkoutListPage> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(const LoadAllWorkouts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Workouts'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/workouts/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Workout'),
      ),
      body: BlocConsumer<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutDeleted) {
            context.read<WorkoutBloc>().add(const LoadAllWorkouts());
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Workout deleted')));
          }
        },
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkoutsLoaded) {
            if (state.workouts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text('No workouts yet'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.push('/workouts/create'),
                      child: const Text('Create your first workout'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: state.workouts.length,
              itemBuilder: (context, index) {
                final workout = state.workouts[index];
                return WorkoutCard(
                  workout: workout,
                  onTap: () =>
                      context.push('/workouts/${workout.id}', extra: workout),
                  onDelete: () {
                    context.read<WorkoutBloc>().add(DeleteWorkout(workout.id));
                  },
                );
              },
            );
          }
          if (state is WorkoutError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
