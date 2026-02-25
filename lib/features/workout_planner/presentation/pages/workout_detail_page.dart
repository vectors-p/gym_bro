import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_event.dart';
import '../bloc/workout_state.dart';

class WorkoutDetailPage extends StatelessWidget {
  final String workoutId;
  final Workout? workout;

  const WorkoutDetailPage({super.key, required this.workoutId, this.workout});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutBloc>()..add(LoadWorkoutById(workoutId)),
      child: _WorkoutDetailView(workoutId: workoutId),
    );
  }
}

class _WorkoutDetailView extends StatefulWidget {
  final String workoutId;

  const _WorkoutDetailView({required this.workoutId});

  @override
  State<_WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<_WorkoutDetailView> {
  void _removeExercise(Workout workout, String exerciseId) {
    context.read<WorkoutBloc>().add(
      RemoveExerciseFromWorkout(workoutId: workout.id, exerciseId: exerciseId),
    );
  }

  void _editExercise(
    BuildContext context,
    Workout workout,
    WorkoutExercise ex,
  ) {
    final setsCtrl = TextEditingController(text: ex.sets.toString());
    final repsCtrl = TextEditingController(text: ex.reps.toString());
    final weightCtrl = TextEditingController(
      text: ex.weight != null
          ? ex.weight!.toStringAsFixed(ex.weight! % 1 == 0 ? 0 : 1)
          : '',
    );
    final workoutBloc = context.read<WorkoutBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              ex.exerciseName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final updated = ex.copyWith(
                  sets: int.tryParse(setsCtrl.text) ?? ex.sets,
                  reps: int.tryParse(repsCtrl.text) ?? ex.reps,
                  weight: weightCtrl.text.isEmpty
                      ? null
                      : double.tryParse(weightCtrl.text),
                  clearWeight: weightCtrl.text.isEmpty,
                );
                workoutBloc.add(
                  UpdateExerciseInWorkout(
                    workoutId: workout.id,
                    exercise: updated,
                  ),
                );
                Navigator.pop(sheetContext);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(Workout workout) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add exercise',
            onPressed: () => context.push('/exercises?workoutId=${workout.id}'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat('Exercises', '${workout.exercises.length}'),
                _Stat('Total Sets', '${workout.totalSets}'),
                _Stat('Est. Time', '${workout.estimatedMinutes} min'),
              ],
            ),
          ),
          if (workout.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                workout.description,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          Expanded(
            child: workout.exercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.playlist_add,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text('No exercises yet'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => context.push(
                            '/exercises?workoutId=${workout.id}',
                          ),
                          child: const Text('Browse Exercises'),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: workout.exercises.length,
                    onReorder: (oldIndex, newIndex) {},
                    itemBuilder: (context, index) {
                      final ex = workout.exercises[index];
                      return ListTile(
                        key: ValueKey('${index}_${ex.exerciseId}'),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: ex.gifUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          ex.exerciseName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${ex.sets} sets × ${ex.reps} reps  •  ${ex.weightDisplay}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () =>
                                  _editExercise(context, workout, ex),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  _removeExercise(workout, ex.exerciseId),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutBloc, WorkoutState>(
      builder: (context, state) {
        if (state is WorkoutLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is WorkoutDetailLoaded) {
          return _buildDetail(state.workout);
        }
        if (state is WorkoutError) {
          return Scaffold(body: Center(child: Text('Error: ${state.message}')));
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
