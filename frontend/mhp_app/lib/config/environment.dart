import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum EnvironmentType { development, production }

class Environment {
  static EnvironmentType _environmentType = EnvironmentType.development;
  static late Map<String, String> _variables;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    // Default to development environment in debug mode, production otherwise
    _environmentType =
        kDebugMode ? EnvironmentType.development : EnvironmentType.production;
    _variables = _getVariables();

    // Load any secure values from secure storage if needed
    await _loadSecureValues();
  }

  static Map<String, String> _getVariables() {
    switch (_environmentType) {
      case EnvironmentType.development:
        return {
          'API_BASE_URL': 'http://192.168.47.204:8000/',
          'API_TIMEOUT': '30000', // milliseconds
          'LOG_LEVEL': 'verbose',
        };
      case EnvironmentType.production:
        return {
          'API_BASE_URL': 'https://api.mentalhealthpartner.com',
          'API_TIMEOUT': '30000', // milliseconds
          'LOG_LEVEL': 'error',
        };
    }
  }

  static Future<void> _loadSecureValues() async {
    // Load secure values if needed
    try {
      final apiKey = await _secureStorage.read(key: 'api_key');
      if (apiKey != null) {
        _variables['API_KEY'] = apiKey;
      }
    } catch (e) {
      debugPrint('Error loading secure values: $e');
    }
  }

  static String get apiBaseUrl => _variables['API_BASE_URL']!;
  static int get apiTimeout => int.parse(_variables['API_TIMEOUT']!);
  static String get logLevel => _variables['LOG_LEVEL']!;
  static bool get isDevelopment =>
      _environmentType == EnvironmentType.development;
}
