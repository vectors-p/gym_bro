import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../../domain/repositories/target_muscle_repository.dart';
import '../data_providers/target_muscle_api_provider.dart';

class TargetMuscleRepositoryImpl implements TargetMuscleRepository {
  final TargetMuscleApiProvider _apiProvider;

  TargetMuscleRepositoryImpl({required TargetMuscleApiProvider apiProvider})
      : _apiProvider = apiProvider;

  @override
  Future<Either<Failure, List<String>>> getTargetMuscleList() async {
    try {
      final list = await _apiProvider.getTargetMuscleList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExercisesByTarget(
    String muscle, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final exercises = await _apiProvider.getExercisesByTarget(
        muscle,
        limit: limit,
        offset: offset,
      );
      return Right(exercises);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}