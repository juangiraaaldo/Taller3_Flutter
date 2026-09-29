import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStorage {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> clear() => _storage.delete(key: _tokenKey);
}
