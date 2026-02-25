import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:gym_bro/features/exercises/presentation/bloc/exercise_event.dart';
import 'package:gym_bro/features/exercises/presentation/bloc/exercise_state.dart';
import 'package:gym_bro/features/exercises/presentation/widgets/exercise_card.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;
  int _currentOffset = 0;

  @override
  void initState() {
    super.initState();
    context.read<ExerciseBloc>().add(const LoadAllExercises());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ExerciseBloc>().state;
      if (state is ExercisesLoaded && state.hasMore) {
        _currentOffset += _pageSize;
        context.read<ExerciseBloc>().add(
          LoadMoreExercises(limit: _pageSize, offset: _currentOffset),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pick up workoutId if we were navigated here from inside a workout
    final workoutId = GoRouterState.of(
      context,
    ).uri.queryParameters['workoutId'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Exercises'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExercisesLoaded || state is ExerciseLoadingMore) {
            final exercises = state is ExercisesLoaded
                ? state.exercises
                : (state as ExerciseLoadingMore).currentExercises;
            final isLoadingMore = state is ExerciseLoadingMore;

            return ListView.builder(
              controller: _scrollController,
              itemCount: exercises.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == exercises.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final exercise = exercises[index];
                return ExerciseCard(
                  exercise: exercise,
                  onTap: () => context.push(
                    // Forward workoutId so detail page knows the context
                    '/exercises/${exercise.id}${workoutId != null ? '?workoutId=$workoutId' : ''}',
                    extra: exercise,
                  ),
                );
              },
            );
          }

          if (state is ExerciseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _currentOffset = 0;
                      context.read<ExerciseBloc>().add(
                        const LoadAllExercises(),
                      );
                    },
                    child: const Text('Retry'),
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
}
