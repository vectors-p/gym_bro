import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const GymApp());
}
