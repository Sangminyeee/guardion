import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guardion/auth_manager.dart';

class ApiService {
  static const String baseUrl = 'http://3.39.253.151:8080';

  static Future<Map<String, dynamic>?> getTemperatureHumidity(
    String serialNumber,
  ) async {
    final token = await AuthManager.getToken();
    print('[DEBUG] request headers → Bearer $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/device-data/temperature-humidity/$serialNumber'),
      headers: headers,
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await AuthManager.clear();
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
    final token = await AuthManager.getToken();
    print('[DEBUG] request headers → Bearer $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/device-data/$serialNumber'),
      headers: headers,
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await AuthManager.clear();
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
    final token = await AuthManager.getToken();
    print('[DEBUG] request headers → Bearer $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      Uri.parse('$baseUrl/device'),
      headers: headers,
      body: json.encode({"serialNumber": serialNumber}),
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await AuthManager.clear();
      throw Exception('인증이 만료되었습니다. 다시 로그인 해주세요.');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to register device');
    }
  }

  static Future<List<dynamic>?> getAlerts() async {
    final token = await AuthManager.getToken();
    print('[DEBUG] request headers → Bearer $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/alert/all'),
      headers: headers,
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await AuthManager.clear();
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
    final token = await AuthManager.getToken();
    print('[DEBUG] request headers → Bearer $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/alert/$alertId'),
      headers: headers,
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await AuthManager.clear();
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
    final token = await AuthManager.getToken();
    print('[DEBUG] request headers → Bearer $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/device'),
      headers: headers,
    );
    try {
      print('getUserDevices 응답: \\${response.body}');
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('getUserDevices 파싱결과: $decoded, 타입: \\${decoded.runtimeType}');
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          return decoded['data'];
        } else {
          return null;
        }
      } else {
        print('❌ getUserDevices 실패: statusCode=\\${response.statusCode}');
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
    final token = await AuthManager.getToken();
    print('[DEBUG] request headers → Bearer $token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/$notificationId'),
      headers: headers,
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await AuthManager.clear();
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

  static Future<String> loginService(String username, String password) async {
    final url = Uri.parse('http://3.39.253.151:8080/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // 1. 헤더에서 Authorization 추출 시도
        final authHeader = response.headers['authorization'];
        if (authHeader != null && authHeader.isNotEmpty) {
          // Bearer <token> 형식일 수 있음
          final parts = authHeader.split(' ');
          if (parts.length == 2 && parts[0].toLowerCase() == 'bearer') {
            return parts[1];
          }
          return authHeader;
        }

        // 2. Set-Cookie에서 추출 시도
        final setCookie = response.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) {
          final match = RegExp(r'token=([^;]+)').firstMatch(setCookie);
          if (match != null) {
            return match.group(1)!;
          }
        }

        throw Exception('로그인 성공했지만 토큰을 찾을 수 없습니다.');
      } else {
        throw Exception(
          '로그인 실패: 상태코드 ${response.statusCode}, 응답: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('로그인 요청 중 오류 발생: $e');
    }
  }
}
