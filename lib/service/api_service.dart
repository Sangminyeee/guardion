import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://3.39.253.151:8080';
  static final _storage = const FlutterSecureStorage();

  static Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  static Future<Map<String, dynamic>?> getTemperatureHumidity(
    String serialNumber,
  ) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      return null;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/device-data/temperature-humidity/$serialNumber'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('✅ 상태코드: \${response.statusCode}');
    print('✅ 응답내용: \${response.body}');
    if (response.statusCode == 401) {
      await _storage.delete(key: 'jwt_token');
      return null;
    }
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['data'] is Map) {
        return decoded['data'];
      } else {
        throw Exception('Unexpected response: $decoded');
      }
    } else {
      throw Exception('Failed to load temperature and humidity');
    }
  }

  static Future<Map<String, dynamic>?> getDeviceData(
    String serialNumber,
  ) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      return null;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/device-data/$serialNumber'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('✅ 상태코드: \${response.statusCode}');
    print('✅ 응답내용: \${response.body}');
    if (response.statusCode == 401) {
      await _storage.delete(key: 'jwt_token');
      return null;
    }
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['data'] is Map) {
        return decoded['data'];
      } else {
        throw Exception('Unexpected response: $decoded');
      }
    } else {
      throw Exception('Failed to load device data');
    }
  }

  static Future<void> registerDevice(String serialNumber) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      throw Exception('토큰 없음');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/device'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({"serialNumber": serialNumber}),
    );
    print('✅ 상태코드: \${response.statusCode}');
    print('✅ 응답내용: \${response.body}');
    if (response.statusCode == 401) {
      await _storage.delete(key: 'jwt_token');
      throw Exception('인증이 만료되었습니다. 다시 로그인 해주세요.');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to register device');
    }
  }

  static Future<List<dynamic>?> getAlerts() async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      return null;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/alert/all'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print('✅ 상태코드: \${response.statusCode}');
    print('✅ 응답내용: \${response.body}');
    if (response.statusCode == 401) {
      await _storage.delete(key: 'jwt_token');
      return null;
    }
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded;
      } else if (decoded is Map && decoded['data'] is List) {
        return decoded['data'];
      } else {
        throw Exception('Unexpected response: $decoded');
      }
    } else {
      throw Exception('Failed to load alerts');
    }
  }

  static Future<Map<String, dynamic>?> getAlert(String alertId) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      return null;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/alert/$alertId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('✅ 상태코드: \${response.statusCode}');
    print('✅ 응답내용: \${response.body}');
    if (response.statusCode == 401) {
      await _storage.delete(key: 'jwt_token');
      return null;
    }
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['data'] is Map) {
        return decoded['data'];
      } else {
        throw Exception('Unexpected response: $decoded');
      }
    } else {
      throw Exception('Failed to load alert');
    }
  }

  static Future<List<dynamic>?> getUserDevices() async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      return null;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/device/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    try {
      print('getUserDevices 응답: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('getUserDevices 파싱결과: $decoded, 타입: \${decoded.runtimeType}');
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          return decoded['data'];
        } else {
          return null;
        }
      } else {
        print('❌ getUserDevices 실패: statusCode=${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ getUserDevices 파싱 예외: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchNotificationDetail(
    String notificationId,
  ) async {
    final token = await _getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      return null;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/$notificationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('✅ 상태코드: \${response.statusCode}');
    print('✅ 응답내용: \${response.body}');
    if (response.statusCode == 401) {
      await _storage.delete(key: 'jwt_token');
      return null;
    }
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['data'] is Map) {
        return decoded['data'];
      } else {
        throw Exception('Unexpected response: $decoded');
      }
    } else {
      throw Exception('Failed to load notification detail');
    }
  }
}
