import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'features/exercises/presentation/bloc/exercise_bloc.dart';
import 'features/body_parts/presentation/bloc/body_part_bloc.dart';
import 'features/equipment/presentation/bloc/equipment_bloc.dart';
import 'features/target_muscle/presentation/bloc/target_muscle_bloc.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/workout_planner/presentation/bloc/workout_bloc.dart';

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExerciseBloc>(create: (_) => sl<ExerciseBloc>()),
        BlocProvider<BodyPartBloc>(create: (_) => sl<BodyPartBloc>()),
        BlocProvider<EquipmentBloc>(create: (_) => sl<EquipmentBloc>()),
        BlocProvider<TargetMuscleBloc>(create: (_) => sl<TargetMuscleBloc>()),
        BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
        BlocProvider<WorkoutBloc>(create: (_) => sl<WorkoutBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Gym App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
