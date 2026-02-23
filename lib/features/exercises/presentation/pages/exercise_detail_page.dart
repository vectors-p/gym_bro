import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/exercise.dart';
import '../bloc/exercise_bloc.dart';
import '../bloc/exercise_event.dart';
import '../bloc/exercise_state.dart';
import '../../../workout_planner/domain/entities/workout_exercise.dart';
import '../../../workout_planner/presentation/bloc/workout_bloc.dart';
import '../../../workout_planner/presentation/bloc/workout_event.dart';
import '../../../workout_planner/presentation/bloc/workout_state.dart';

class ExerciseDetailPage extends StatefulWidget {
  final String exerciseId;
  final Exercise? exercise;

  const ExerciseDetailPage({
    super.key,
    required this.exerciseId,
    this.exercise,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.exercise == null) {
      context.read<ExerciseBloc>().add(LoadExerciseById(widget.exerciseId));
    }
  }

  void _showAddToWorkoutSheet(BuildContext context, Exercise exercise) {
    // Load workouts before showing sheet
    context.read<WorkoutBloc>().add(const LoadAllWorkouts());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is WorkoutsLoaded) {
            if (state.workouts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No workouts yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/workouts/create');
                      },
                      child: const Text('Create a Workout'),
                    ),
                  ],
                ),
              );
            }

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              maxChildSize: 0.85,
              builder: (_, scrollCtrl) => Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add to Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollCtrl,
                      itemCount: state.workouts.length,
                      itemBuilder: (context, index) {
                        final workout = state.workouts[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.fitness_center, size: 18),
                          ),
                          title: Text(workout.name),
                          subtitle: Text(
                            '${workout.exercises.length} exercises',
                          ),
                          onTap: () {
                            final router = GoRouter.of(
                              context,
                            ); // ← capture before dismissing
                            context.read<WorkoutBloc>().add(
                              AddExerciseToWorkout(
                                workoutId: workout.id,
                                exercise: WorkoutExercise(
                                  exerciseId: exercise.id,
                                  exerciseName: exercise.name,
                                  gifUrl: exercise.gifUrl,
                                  targetMuscle: exercise.primaryTarget,
                                  sets: 3,
                                  reps: 12,
                                  restSeconds: 60,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added to ${workout.name}'),
                                action: SnackBarAction(
                                  label: 'View',
                                  onPressed: () {
                                    router.push('/workouts/${workout.id}');
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(Exercise exercise) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Animated header with the exercise GIF
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: exercise.gifUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey.shade900,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade900,
                  child: const Icon(Icons.fitness_center, size: 64),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(
                        label: exercise.primaryBodyPart,
                        icon: Icons.accessibility_new,
                      ),
                      _MetaChip(
                        label: exercise.primaryTarget,
                        icon: Icons.sports_gymnastics,
                      ),
                      _MetaChip(
                        label: exercise.primaryEquipment,
                        icon: Icons.fitness_center,
                      ),
                    ],
                  ),

                  // Secondary muscles
                  if (exercise.secondaryMuscles.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Secondary Muscles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: exercise.secondaryMuscles
                          .map(
                            (m) => Chip(
                              label: Text(
                                m,
                                style: const TextStyle(fontSize: 12),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  // Instructions
                  const SizedBox(height: 20),
                  const Text(
                    'How to Perform',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ...exercise.instructions.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // FAB clearance
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddToWorkoutSheet(context, exercise),
        icon: const Icon(Icons.playlist_add),
        label: const Text('Add to Workout'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If exercise passed via GoRouter extra — render immediately
    if (widget.exercise != null) return _buildBody(widget.exercise!);

    return Scaffold(
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExerciseDetailLoaded) {
            return _buildBody(state.exercise);
          }
          if (state is ExerciseError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
