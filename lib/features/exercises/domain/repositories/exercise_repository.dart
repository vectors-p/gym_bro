import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, List<Exercise>>> getAllExercises({
    int limit = 10,
    int offset = 0,
  });

  Future<Either<Failure, Exercise>> getExerciseById(String id);

  Future<Either<Failure, List<Exercise>>> searchExercisesByName(String name);
}
