import 'package:dio/dio.dart';
import 'package:gym_bro/core/constatnts/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../exercises/data/models/exercise_model.dart';

class BodyPartApiProvider {
  final ApiClient _apiClient;

  BodyPartApiProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  /// GET /bodyparts
  /// Returns [{ "name": "back" }, { "name": "chest" }, ...]
  Future<List<String>> getBodyPartList() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.bodyPartList);
      final data = response.data['data'] as List;
      return data.map((e) => e['name'] as String).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  /// GET /bodyparts/{bodyPart}/exercises?limit=&offset=
  Future<List<ExerciseModel>> getExercisesByBodyPart(
    String bodyPart, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.exercisesByBodyPart}/$bodyPart/exercises',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = response.data['data'] as List;
      return data.map((json) => ExerciseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }
}
