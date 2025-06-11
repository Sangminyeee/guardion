import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 1. 데이터 모델 정의
class DeviceTempHumidityData {
  final double temperature;
  final double temperatureDiff;
  final double humidity;
  final double humidityDiff;
  final bool door;

  DeviceTempHumidityData({
    required this.temperature,
    required this.temperatureDiff,
    required this.humidity,
    required this.humidityDiff,
    required this.door,
  });

  factory DeviceTempHumidityData.fromJson(Map<String, dynamic> json) {
    return DeviceTempHumidityData(
      temperature: (json['temperature'] as num).toDouble(),
      temperatureDiff: (json['temperatureDiff'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      humidityDiff: (json['humidityDiff'] as num).toDouble(),
      door: json['door'] as bool,
    );
  }
}

// 2. 백엔드 데이터 요청 함수
Future<DeviceTempHumidityData?> fetchTempHumidity({
  required String serialNumber,
}) async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'jwt_token');
  if (token == null) {
    print('❌ 토큰이 없습니다. 로그인 필요.');
    return null;
  }
  final uri = Uri.parse(
    'http://3.39.253.151:8080/device-data/getTemperatureHumidity?serialNumber=$serialNumber',
  );
  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await storage.delete(key: 'jwt_token');
      // 로그아웃 처리 필요시 Navigator 등 활용
      return null;
    }
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      if (jsonBody['success'] == true && jsonBody['data'] != null) {
        return DeviceTempHumidityData.fromJson(jsonBody['data']);
      } else {
        throw Exception('데이터가 없습니다.');
      }
    } else {
      throw Exception('서버 오류');
    }
  } catch (e) {
    print('❌ 예외 발생: $e');
    return null;
  }
}

// 3. AlertDetailPage 구현
class AlertDetailPage extends StatelessWidget {
  final String notificationId;
  const AlertDetailPage({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String nid =
        args != null ? args['alert']['id'].toString() : notificationId;
    return Scaffold(
      appBar: AppBar(title: const Text('알림 상세')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: ApiService.fetchNotificationDetail(nid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '데이터를 불러올 수 없습니다.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('데이터가 없습니다.'));
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              ...data.keys.map(
                (k) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        k,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          data[k]?.toString() ?? '-',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// 4. 예시: 앱 시작점 및 AlertDetailPage 호출
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alert Detail Demo',
      home: const AlertDetailPage(notificationId: 'AX0132F'), // 테스트용 알림 ID
    );
  }
}
