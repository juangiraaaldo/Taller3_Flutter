import 'package:flutter/foundation.dart';

abstract final class ApiConfig {
  static const _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override.replaceFirst(RegExp(r'/$'), '');
    if (kIsWeb) return 'http://localhost:3000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static String get authUrl => '$baseUrl/api/auth';
  static String get tasksUrl => '$baseUrl/api/tasks';
}
