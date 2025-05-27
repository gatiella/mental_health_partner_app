import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'di/injection_container.dart' as di;
import 'config/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize environment variables
  await Environment.init();

  // Initialize dependency injection
  await di.init();

  runApp(const MentalHealthApp());
}
