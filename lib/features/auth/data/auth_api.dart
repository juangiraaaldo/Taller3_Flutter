import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static String get _baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api/auth';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api/auth';
    }
    return 'http://localhost:3000/api/auth';
  }

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return _messageFrom(response, successCode: 201);
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _messageFrom(response);
  }

  String _messageFrom(http.Response response, {int successCode = 200}) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == successCode) {
      return data['message'] as String? ?? 'Operación completada';
    }

    throw Exception(data['message'] as String? ?? 'Error en la solicitud');
  }
}