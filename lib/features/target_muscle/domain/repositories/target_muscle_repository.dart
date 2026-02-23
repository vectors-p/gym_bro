import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../exercises/domain/entities/exercise.dart';

abstract class TargetMuscleRepository {
  Future<Either<Failure, List<String>>> getTargetMuscleList();

  Future<Either<Failure, List<Exercise>>> getExercisesByTarget(
    String muscle, {
    int limit = 20,
    int offset = 0,
  });
}
