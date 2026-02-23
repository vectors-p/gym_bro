import 'package:dio/dio.dart';
import 'package:gym_bro/core/constatnts/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../exercises/data/models/exercise_model.dart';

class TargetMuscleApiProvider {
  final ApiClient _apiClient;

  TargetMuscleApiProvider({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// GET /muscles
  /// Returns [{ "name": "biceps" }, { "name": "triceps" }, ...]
  Future<List<String>> getTargetMuscleList() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.targetMuscleList);
      final data = response.data['data'] as List;
      return data.map((e) => e['name'] as String).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  /// GET /muscles/{muscle}/exercises?limit=&offset=
  Future<List<ExerciseModel>> getExercisesByTarget(
    String muscle, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.exercisesByTarget}/$muscle/exercises',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = response.data['data'] as List;
      return data.map((json) => ExerciseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }
}
