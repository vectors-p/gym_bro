import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/exercises/domain/entities/exercise.dart';
import '../../features/exercises/presentation/pages/exercise_detail_page.dart';
import '../../features/exercises/presentation/pages/exercise_list_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/body_parts/presentation/pages/body_part_exercises_page.dart';
import '../../features/equipment/presentation/pages/equipment_list_page.dart';
import '../../features/equipment/presentation/pages/equipment_exercises_page.dart';
import '../../features/target_muscle/presentation/pages/target_muscle_list_page.dart';
import '../../features/target_muscle/presentation/pages/target_muscle_exercises_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/workout_planner/presentation/pages/workout_list_page.dart';
import '../../features/workout_planner/presentation/pages/workout_detail_page.dart';
import '../../features/workout_planner/presentation/pages/workout_create_page.dart';
import '../../features/workout_planner/domain/entities/workout.dart';

class AppRouter {
  // Route paths
  static const String home = '/';
  static const String exercises = '/exercises';
  static const String exerciseDetail = '/exercises/:id';
  static const String bodyPartExercises = '/body-part/:bodyPart';
  static const String equipment = '/equipment';
  static const String equipmentExercises = '/equipment/:type';
  static const String targetMuscle = '/target-muscle';
  static const String targetMuscleExercises = '/target-muscle/:muscle';
  static const String search = '/search';
  static const String workouts = '/workouts';
  static const String workoutDetail = '/workouts/:workoutId';
  static const String workoutCreate = '/workouts/create';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      // ── Home ──────────────────────────────────────────
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // ── Exercises ─────────────────────────────────────
      GoRoute(
        path: exercises,
        name: 'exercises',
        builder: (context, state) => const ExerciseListPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'exerciseDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final exercise = state.extra as Exercise?;
              return ExerciseDetailPage(exerciseId: id, exercise: exercise);
            },
          ),
        ],
      ),

      // ── Body Part ──────────────────────────────────────
      GoRoute(
        path: '/body-part/:bodyPart',
        name: 'bodyPartExercises',
        builder: (context, state) {
          final bodyPart = state.pathParameters['bodyPart']!;
          return BodyPartExercisesPage(bodyPart: bodyPart);
        },
      ),

      // ── Equipment ─────────────────────────────────────
      GoRoute(
        path: equipment,
        name: 'equipment',
        builder: (context, state) => const EquipmentListPage(),
        routes: [
          GoRoute(
            path: ':type',
            name: 'equipmentExercises',
            builder: (context, state) {
              final type = state.pathParameters['type']!;
              return EquipmentExercisesPage(equipmentType: type);
            },
          ),
        ],
      ),

      // ── Target Muscle ─────────────────────────────────
      GoRoute(
        path: targetMuscle,
        name: 'targetMuscle',
        builder: (context, state) => const TargetMuscleListPage(),
        routes: [
          GoRoute(
            path: ':muscle',
            name: 'targetMuscleExercises',
            builder: (context, state) {
              final muscle = state.pathParameters['muscle']!;
              return TargetMuscleExercisesPage(muscle: muscle);
            },
          ),
        ],
      ),

      // ── Search ────────────────────────────────────────
      GoRoute(
        path: search,
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return SearchPage(initialQuery: query);
        },
      ),

      // ── Workout Planner ───────────────────────────────
      GoRoute(
        path: workouts,
        name: 'workouts',
        builder: (context, state) => const WorkoutListPage(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'workoutCreate',
            builder: (context, state) => const WorkoutCreatePage(),
          ),
          GoRoute(
            path: ':workoutId',
            name: 'workoutDetail',
            builder: (context, state) {
              final workoutId = state.pathParameters['workoutId']!;
              final workout = state.extra as Workout?;
              return WorkoutDetailPage(workoutId: workoutId, workout: workout);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
