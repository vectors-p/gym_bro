import 'package:dio/dio.dart';
import 'package:gym_bro/core/constatnts/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../exercises/data/models/exercise_model.dart';

class EquipmentApiProvider {
  final ApiClient _apiClient;

  EquipmentApiProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  /// GET /equipments
  /// Returns [{ "name": "dumbbell" }, { "name": "barbell" }, ...]
  Future<List<String>> getEquipmentList() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.equipmentList);
      final data = response.data['data'] as List;
      return data.map((e) => e['name'] as String).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }

  /// GET /equipments/{equipment}/exercises?limit=&offset=
  Future<List<ExerciseModel>> getExercisesByEquipment(
    String equipment, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.exercisesByEquipment}/$equipment/exercises',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final data = response.data['data'] as List;
      return data.map((json) => ExerciseModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error');
    }
  }
}
