import 'package:flutter/material.dart';

class AppConstants {
  // Body part display metadata — icon + gradient color pair
  static const Map<String, BodyPartMeta> bodyPartMeta = {
    'back': BodyPartMeta(
      icon: Icons.accessibility_new,
      color: Color(0xFF1565C0),
      label: 'Back',
    ),
    'cardio': BodyPartMeta(
      icon: Icons.favorite,
      color: Color(0xFFB71C1C),
      label: 'Cardio',
    ),
    'chest': BodyPartMeta(
      icon: Icons.fitness_center,
      color: Color(0xFF4A148C),
      label: 'Chest',
    ),
    'lower arms': BodyPartMeta(
      icon: Icons.pan_tool,
      color: Color(0xFF1B5E20),
      label: 'Lower Arms',
    ),
    'lower legs': BodyPartMeta(
      icon: Icons.directions_walk,
      color: Color(0xFF33691E),
      label: 'Lower Legs',
    ),
    'neck': BodyPartMeta(
      icon: Icons.person,
      color: Color(0xFF004D40),
      label: 'Neck',
    ),
    'shoulders': BodyPartMeta(
      icon: Icons.sports_gymnastics,
      color: Color(0xFFE65100),
      label: 'Shoulders',
    ),
    'upper arms': BodyPartMeta(
      icon: Icons.sports_handball,
      color: Color(0xFF880E4F),
      label: 'Upper Arms',
    ),
    'upper legs': BodyPartMeta(
      icon: Icons.directions_run,
      color: Color(0xFF3E2723),
      label: 'Upper Legs',
    ),
    'waist': BodyPartMeta(
      icon: Icons.self_improvement,
      color: Color(0xFF006064),
      label: 'Waist',
    ),
  };
}

class BodyPartMeta {
  final IconData icon;
  final Color color;
  final String label;

  const BodyPartMeta({
    required this.icon,
    required this.color,
    required this.label,
  });
}
