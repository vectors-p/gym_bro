import 'package:get_it/get_it.dart';
import 'package:gym_bro/core/network/api_client.dart';

// Exercises
import '../../features/exercises/data/data_providers/exercise_api_provider.dart';
import '../../features/exercises/data/repositories/exercise_repository_impl.dart'
    as exercise_impl;
import '../../features/exercises/domain/repositories/exercise_repository.dart';
import '../../features/exercises/presentation/bloc/exercise_bloc.dart';

// Body Parts
import '../../features/body_parts/data/data_providers/body_part_api_provider.dart';
import '../../features/body_parts/data/repositories/body_part_repository_impl.dart'
    as body_part_impl;
import '../../features/body_parts/domain/repositories/body_part_repository.dart';
import '../../features/body_parts/presentation/bloc/body_part_bloc.dart';

// Equipment
import '../../features/equipment/data/data_providers/equipment_api_provider.dart';
import '../../features/equipment/data/repositories/equipment_repository_impl.dart'
    as equipment_impl;
import '../../features/equipment/domain/repositories/equipment_repository.dart';
import '../../features/equipment/presentation/bloc/equipment_bloc.dart';

// Target Muscle
import '../../features/target_muscle/data/data_providers/target_muscle_api_provider.dart';
import '../../features/target_muscle/data/repositories/target_muscle_repository_impl.dart'
    as target_impl;
import '../../features/target_muscle/domain/repositories/target_muscle_repository.dart';
import '../../features/target_muscle/presentation/bloc/target_muscle_bloc.dart';

// Search
import '../../features/search/presentation/bloc/search_bloc.dart';

// Workout Planner
import '../../features/workout_planner/data/data_providers/workout_local_provider.dart';
import '../../features/workout_planner/data/repositories/workout_repository_impl.dart'
    as workout_impl;
import '../../features/workout_planner/domain/repositories/workout_repository.dart';
import '../../features/workout_planner/presentation/bloc/workout_bloc.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // ── Core ─────────────────────────────────────────────
  sl.registerLazySingleton(() => ApiClient());

  // ── Data Providers ───────────────────────────────────
  sl.registerLazySingleton(() => ExerciseApiProvider(apiClient: sl()));
  sl.registerLazySingleton(() => BodyPartApiProvider(apiClient: sl()));
  sl.registerLazySingleton(() => EquipmentApiProvider(apiClient: sl()));
  sl.registerLazySingleton(() => TargetMuscleApiProvider(apiClient: sl()));
  sl.registerLazySingleton(() => WorkoutLocalProvider());

  // ── Repositories ─────────────────────────────────────
  sl.registerLazySingleton<ExerciseRepository>(
    () => exercise_impl.ExerciseRepositoryImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<BodyPartRepository>(
    () => body_part_impl.BodyPartRepositoryImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<EquipmentRepository>(
    () => equipment_impl.EquipmentRepositoryImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<TargetMuscleRepository>(
    () => target_impl.TargetMuscleRepositoryImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<WorkoutRepository>(
    () => workout_impl.WorkoutRepositoryImpl(localProvider: sl()),
  );

  // ── BLoCs ────────────────────────────────────────────
  sl.registerFactory(() => ExerciseBloc(repository: sl()));
  sl.registerFactory(() => BodyPartBloc(repository: sl()));
  sl.registerFactory(() => EquipmentBloc(repository: sl()));
  sl.registerFactory(() => TargetMuscleBloc(repository: sl()));
  sl.registerFactory(() => SearchBloc(repository: sl<ExerciseRepository>()));
  sl.registerFactory(() => WorkoutBloc(repository: sl()));
}
