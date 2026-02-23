import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../data_providers/exercise_api_provider.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseApiProvider _apiProvider;

  ExerciseRepositoryImpl({required ExerciseApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<Either<Failure, List<Exercise>>> getAllExercises({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final result = await _apiProvider.getAllExercises(
        limit: limit,
        offset: offset,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Exercise>> getExerciseById(String id) async {
    try {
      final result = await _apiProvider.getExerciseById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> searchExercisesByName(
    String name,
  ) async {
    try {
      final result = await _apiProvider.searchExercisesByName(name);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
