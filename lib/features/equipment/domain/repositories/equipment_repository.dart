import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../exercises/domain/entities/exercise.dart';

abstract class EquipmentRepository {
  Future<Either<Failure, List<String>>> getEquipmentList();

  Future<Either<Failure, List<Exercise>>> getExercisesByEquipment(
    String equipment, {
    int limit = 20,
    int offset = 0,
  });
}
