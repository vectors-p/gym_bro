import 'package:dio/dio.dart';
import 'package:gym_bro/core/constatnts/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/exercise_model.dart';

class ExerciseApiProvider {
  final ApiClient _apiClient;

  ExerciseApiProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  /// GET /exercises?limit=&offset=
  Future<List<ExerciseModel>> getAllExercises({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.exercises,
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = response.data['data'] as List;
      return data.map((json) => ExerciseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  /// GET /exercises/{id}
  /// Note: data is a single object, not a list
  Future<ExerciseModel> getExerciseById(String id) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.exerciseById}/$id',
      );
      return ExerciseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  /// GET /exercises/search?q={name}
  Future<List<ExerciseModel>> searchExercisesByName(String name) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.exercisesSearch,
        queryParameters: {'q': name},
      );
      final data = response.data['data'] as List;
      return data.map((json) => ExerciseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }
}
