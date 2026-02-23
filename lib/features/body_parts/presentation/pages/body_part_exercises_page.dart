import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/core/constatnts/app_constants.dart';
import '../bloc/body_part_bloc.dart';
import '../bloc/body_part_event.dart';
import '../bloc/body_part_state.dart';
import '../../../exercises/presentation/widgets/exercise_card.dart';

class BodyPartExercisesPage extends StatefulWidget {
  final String bodyPart;

  const BodyPartExercisesPage({super.key, required this.bodyPart});

  @override
  State<BodyPartExercisesPage> createState() => _BodyPartExercisesPageState();
}

class _BodyPartExercisesPageState extends State<BodyPartExercisesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BodyPartBloc>().add(LoadExercisesByBodyPart(widget.bodyPart));
  }

  @override
  Widget build(BuildContext context) {
    final meta = AppConstants.bodyPartMeta[widget.bodyPart];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                meta?.label ?? widget.bodyPart,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      meta?.color ?? Colors.deepOrange,
                      (meta?.color ?? Colors.deepOrange).withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    meta?.icon ?? Icons.fitness_center,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<BodyPartBloc, BodyPartState>(
            builder: (context, state) {
              if (state is BodyPartLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is BodyPartExercisesLoaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final exercise = state.exercises[index];
                    return ExerciseCard(
                      exercise: exercise,
                      onTap: () => context.push(
                        '/exercises/${exercise.id}',
                        extra: exercise,
                      ),
                    );
                  }, childCount: state.exercises.length),
                );
              }
              if (state is BodyPartError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              }
              return const SliverFillRemaining(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}
