import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
Future<DeviceTempHumidityData> fetchTempHumidity({
  required String serialNumber,
}) async {
  final uri = Uri.parse(
      'http://3.39.253.151:8080/device-data/getTemperatureHumidity?serialNumber=$serialNumber');
  final response = await http.get(uri);

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
}

// 3. AlertDetailPage 구현
class AlertDetailPage extends StatelessWidget {
  final String serialNumber;

  const AlertDetailPage({super.key, required this.serialNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 상세')),
      body: FutureBuilder<DeviceTempHumidityData>(
        future: fetchTempHumidity(serialNumber: serialNumber),
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
          if (!snapshot.hasData) {
            return const Center(child: Text('데이터가 없습니다.'));
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _dataDetailRow('현재 온도', '${data.temperature}°C', Colors.red),
              _dataDetailRow('현재 습도', '${data.humidity}%', const Color(0xFF00A9E0)),
              _dataDetailRow('온도 변화율', '${data.temperatureDiff}%', Colors.orange),
              _dataDetailRow('습도 변화율', '${data.humidityDiff}%', Colors.blueAccent),
              _dataDetailRow('뚜껑 열림 여부', data.door ? '열림' : '닫힘', Colors.green),
            ],
          );
        },
      ),
    );
  }

  Widget _dataDetailRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
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
      home: const AlertDetailPage(serialNumber: 'AX0132F'), // 테스트용 시리얼넘버
    );
  }
}
