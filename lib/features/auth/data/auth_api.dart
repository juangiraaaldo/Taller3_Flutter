import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../core/constants/api_config.dart';
import '../../../core/storage/session_storage.dart';
import 'auth_user.dart';

class AuthApi {
  final _sessionStorage = SessionStorage();

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.authUrl}/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return _messageFrom(response, successCode: 201);
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.authUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = _dataFrom(response);
    final token = data['token'] as String?;
    final userData = data['user'] as Map<String, dynamic>?;
    if (token == null || userData == null) {
      throw Exception('La respuesta de inicio de sesión está incompleta');
    }

    await _sessionStorage.saveToken(token);
    return AuthUser.fromJson(userData);
  }

  Future<AuthUser> getProfile() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.authUrl}/profile'),
      headers: await _authorizedHeaders(),
    );
    final data = _dataFrom(response);
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<bool> restoreSession() async {
    if (await _sessionStorage.readToken() == null) return false;
    try {
      await getProfile();
      return true;
    } catch (_) {
      await _sessionStorage.clear();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('${ApiConfig.authUrl}/logout'),
        headers: await _authorizedHeaders(),
      );
    } finally {
      await _sessionStorage.clear();
    }
  }

  Future<Map<String, String>> authorizedHeaders() => _authorizedHeaders();

  Future<Map<String, String>> _authorizedHeaders() async {
    final token = await _sessionStorage.readToken();
    if (token == null) throw Exception('Inicia sesión para continuar');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  String _messageFrom(http.Response response, {int successCode = 200}) {
    final data = _dataFrom(response, successCode: successCode);
    return data['message'] as String? ?? 'Operación completada';
  }

  Map<String, dynamic> _dataFrom(
    http.Response response, {
    int successCode = 200,
  }) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == successCode) {
      return data;
    }

    throw Exception(data['message'] as String? ?? 'Error en la solicitud');
  }
}
