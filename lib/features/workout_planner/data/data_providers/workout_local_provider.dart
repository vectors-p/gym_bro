import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/workout_model.dart';

class WorkoutLocalProvider {
  static const String _workoutsKey = 'workouts';

  Future<List<WorkoutModel>> getAllWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_workoutsKey);
      if (jsonString == null) return [];
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load workouts: $e');
    }
  }

  Future<void> saveWorkouts(List<WorkoutModel> workouts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = workouts.map((w) => w.toJson()).toList();
      await prefs.setString(_workoutsKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException(message: 'Failed to save workouts: $e');
    }
  }

  Future<WorkoutModel?> getWorkoutById(String id) async {
    final workouts = await getAllWorkouts();
    try {
      return workouts.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}
