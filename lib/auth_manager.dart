import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  static const _storage = FlutterSecureStorage();
  static String? _token; // in-memory cache

  /* 저장 (로그인 직후 사용) */
  static Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: 'jwt_token', value: token);
  }

  /* 읽기 (API 호출 시 사용) */
  static Future<String?> getToken() async {
    if (_token != null) return _token;
    _token = await _storage.read(key: 'jwt_token');
    return _token;
  }

  /* 로그아웃 등 */
  static Future<void> clear() async {
    _token = null;
    await _storage.delete(key: 'jwt_token');
  }
}
