import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../exercises/domain/entities/exercise.dart';

abstract class BodyPartRepository {
  Future<Either<Failure, List<String>>> getBodyPartList();

  Future<Either<Failure, List<Exercise>>> getExercisesByBodyPart(
    String bodyPart, {
    int limit = 20,
    int offset = 0,
  });
}
