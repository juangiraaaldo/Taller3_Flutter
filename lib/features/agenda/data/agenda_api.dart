import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_config.dart';
import '../../auth/data/auth_api.dart';
import 'task_model.dart';

class AgendaApi {
  final _authApi = AuthApi();

  Future<List<TaskModel>> getTasks() async {
    final response = await http.get(
      Uri.parse(ApiConfig.tasksUrl),
      headers: await _authApi.authorizedHeaders(),
    );
    final data = _dataFrom(response);
    return (data['tasks'] as List<dynamic>)
        .map((task) => TaskModel.fromJson(task as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTask(TaskModel task) async {
    final response = await http.post(
      Uri.parse(ApiConfig.tasksUrl),
      headers: await _authApi.authorizedHeaders(),
      body: jsonEncode(task.toJson()),
    );
    _dataFrom(response, successCode: 201);
  }

  Future<void> updateTask(TaskModel task) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.tasksUrl}/${task.id}'),
      headers: await _authApi.authorizedHeaders(),
      body: jsonEncode(task.toJson()),
    );
    _dataFrom(response);
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.tasksUrl}/$id'),
      headers: await _authApi.authorizedHeaders(),
    );
    _dataFrom(response);
  }

  Map<String, dynamic> _dataFrom(
    http.Response response, {
    int successCode = 200,
  }) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == successCode) return data;
    throw Exception(data['message'] as String? ?? 'Error en la solicitud');
  }
}
