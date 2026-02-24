import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/core/constatnts/app_constants.dart';
import 'package:gym_bro/features/body_parts/presentation/bloc/body_part_bloc.dart';
import 'package:gym_bro/features/body_parts/presentation/bloc/body_part_event.dart';
import 'package:gym_bro/features/body_parts/presentation/bloc/body_part_state.dart';
import 'package:gym_bro/features/exercises/presentation/widgets/exercise_card.dart';

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
    final color = meta?.color ?? const Color(0xFFFF4500);
    final gradientEnd = meta?.gradientEnd ?? const Color(0xFFBF360C);
    final label = meta?.label ?? widget.bodyPart;
    final icon = meta?.icon ?? Icons.fitness_center;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 160,
            backgroundColor: const Color(0xFF0A0A0A),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background using the body part color
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withValues(alpha: .35),
                          const Color(0xFF0A0A0A),
                        ],
                      ),
                    ),
                  ),
                  // Ghost icon
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(
                      icon,
                      size: 160,
                      color: color.withValues(alpha: .07),
                    ),
                  ),
                  // Bottom fade to background
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, const Color(0xFF0A0A0A)],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
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
                if (state.exercises.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No exercises found for $label',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
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
