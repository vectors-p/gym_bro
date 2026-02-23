import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../../domain/repositories/body_part_repository.dart';
import '../data_providers/body_part_api_provider.dart';

class BodyPartRepositoryImpl implements BodyPartRepository {
  final BodyPartApiProvider _apiProvider;

  BodyPartRepositoryImpl({required BodyPartApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<Either<Failure, List<String>>> getBodyPartList() async {
    try {
      final list = await _apiProvider.getBodyPartList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExercisesByBodyPart(
    String bodyPart, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final exercises = await _apiProvider.getExercisesByBodyPart(
        bodyPart,
        limit: limit,
        offset: offset,
      );
      return Right(exercises);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
