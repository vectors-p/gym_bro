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
  final String? workoutId; // ← passed when navigating from inside a workout

  const ExerciseDetailPage({
    super.key,
    required this.exerciseId,
    this.exercise,
    this.workoutId,
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

  // ── Used when coming from outside a workout ──────────────
  void _showAddToWorkoutSheet(BuildContext context, Exercise exercise) {
    final router = GoRouter.of(context);
    final workoutBloc = context.read<WorkoutBloc>();
    workoutBloc.add(const LoadAllWorkouts());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocBuilder<WorkoutBloc, WorkoutState>(
        bloc: workoutBloc,
        builder: (_, state) {
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
                        router.push('/workouts/create');
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
                      itemBuilder: (listContext, index) {
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
                            Navigator.pop(context);
                            _showExerciseConfigSheet(
                              context,
                              exercise,
                              workout.id,
                              workout.name,
                              workoutBloc,
                              router,
                              fromInsideWorkout: false,
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

  // ── Config sheet: sets / reps / weight ───────────────────
  void _showExerciseConfigSheet(
    BuildContext context,
    Exercise exercise,
    String workoutId,
    String workoutName,
    WorkoutBloc workoutBloc,
    GoRouter router, {
    bool fromInsideWorkout = false,
  }) {
    final setsCtrl = TextEditingController(text: '3');
    final repsCtrl = TextEditingController(text: '12');
    final weightCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              exercise.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (workoutName.isNotEmpty)
              Text(
                'Adding to $workoutName',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: repsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: weightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final sets = int.tryParse(setsCtrl.text) ?? 3;
                final reps = int.tryParse(repsCtrl.text) ?? 12;
                final weight = double.tryParse(weightCtrl.text);

                workoutBloc.add(
                  AddExerciseToWorkout(
                    workoutId: workoutId,
                    exercise: WorkoutExercise(
                      exerciseId: exercise.id,
                      exerciseName: exercise.name,
                      gifUrl: exercise.gifUrl,
                      targetMuscle: exercise.primaryTarget,
                      sets: sets,
                      reps: reps,
                      weight: weight,
                    ),
                  ),
                );
                Navigator.pop(sheetContext);

                if (fromInsideWorkout) {
                  // Just pop back to workout detail
                  router.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to $workoutName'),
                      action: SnackBarAction(
                        label: 'View',
                        onPressed: () {
                          router.go('/');
                          router.push('/workouts');
                          router.push('/workouts/$workoutId');
                        },
                      ),
                    ),
                  );
                }
              },
              child: const Text('Add to Workout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(Exercise exercise) {
    final fromInsideWorkout = widget.workoutId != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (fromInsideWorkout) {
            // Skip workout picker — go straight to config sheet
            _showExerciseConfigSheet(
              context,
              exercise,
              widget.workoutId!,
              '',
              context.read<WorkoutBloc>(),
              GoRouter.of(context),
              fromInsideWorkout: true,
            );
          } else {
            _showAddToWorkoutSheet(context, exercise);
          }
        },
        icon: const Icon(Icons.playlist_add),
        label: const Text('Add to Workout'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .3),
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
