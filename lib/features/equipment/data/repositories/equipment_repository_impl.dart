import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../exercises/domain/entities/exercise.dart';
import '../../domain/repositories/equipment_repository.dart';
import '../data_providers/equipment_api_provider.dart';

class EquipmentRepositoryImpl implements EquipmentRepository {
  final EquipmentApiProvider _apiProvider;

  EquipmentRepositoryImpl({required EquipmentApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<Either<Failure, List<String>>> getEquipmentList() async {
    try {
      final list = await _apiProvider.getEquipmentList();
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExercisesByEquipment(
    String equipment, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final exercises = await _apiProvider.getExercisesByEquipment(
        equipment,
        limit: limit,
        offset: offset,
      );
      return Right(exercises);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
