// 1. import 정리
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'add_housing_result_dialog.dart';

// 2. 데이터 모델 정의 (생략, 기존과 동일)
// AlertDetailData 모델 정의
class AlertDetailData {
  final String deviceSerialNumber;
  final DateTime alertTime;
  final String alertType;
  final String alertMessage;
  final double internalTemperature;
  final double internalHumidity;
  final double temperatureDiff;
  final double humidityDiff;
  final String doorStatus;
  final bool batteryExists;
  final bool beepStatus;
  final bool lightStatus;

  AlertDetailData({
    required this.deviceSerialNumber,
    required this.alertTime,
    required this.alertType,
    required this.alertMessage,
    required this.internalTemperature,
    required this.internalHumidity,
    required this.temperatureDiff,
    required this.humidityDiff,
    required this.doorStatus,
    required this.batteryExists,
    required this.beepStatus,
    required this.lightStatus,
  });

  factory AlertDetailData.fromJson(Map<String, dynamic> json) {
    return AlertDetailData(
      deviceSerialNumber: json['deviceSerialNumber'] as String? ?? '',
      alertTime: DateTime.parse(json['alertTime'] as String),
      alertType: json['alertType'] as String? ?? '',
      alertMessage: json['alertMessage'] as String? ?? '',
      internalTemperature: (json['internalTemperature'] as num?)?.toDouble() ?? 0,
      internalHumidity: (json['internalHumidity'] as num?)?.toDouble() ?? 0,
      temperatureDiff: (json['temperatureDiff'] as num?)?.toDouble() ?? 0,
      humidityDiff: (json['humidityDiff'] as num?)?.toDouble() ?? 0,
      doorStatus: json['doorStatus'] as String? ?? '',
      batteryExists: json['batteryExists'] as bool? ?? false,
      beepStatus: json['beepStatus'] as bool? ?? false,
      lightStatus: json['lightStatus'] as bool? ?? false,
    );
  }
}

// 3. 알림 상세 데이터 요청 함수
Future<AlertDetailData?> fetchAlertDetail(int alertId) async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'jwt_token');
  if (token == null) {
    print('❌ 토큰이 없습니다. 로그인 필요.');
    return null;
  }

  final uri = Uri.parse(
    'http://3.39.253.151:8080/alert/$alertId',
  );
  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('✅ 상태코드: ${response.statusCode}');
    print('✅ 응답내용: ${response.body}');
    if (response.statusCode == 401) {
      await storage.delete(key: 'jwt_token');
      return null;
    }
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      if (jsonBody['success'] == true && jsonBody['data'] != null) {
        return AlertDetailData.fromJson(jsonBody['data']);
      }
    }
    return null;
  } catch (e) {
    print('❌ 예외 발생: $e');
    return null;
  }
}

// 4. AlertDetailPage 위젯
class AlertDetailPage extends StatelessWidget {


  final int alertId;
  const AlertDetailPage({super.key, required this.alertId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 상세')),
      body: FutureBuilder<AlertDetailData?>(
        future: fetchAlertDetail(alertId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('데이터를 불러올 수 없습니다.'));
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _detailRow('기기 시리얼', data.deviceSerialNumber),
              _detailRow('알림 시간', data.alertTime.toString()),
              _detailRow('알림 유형', data.alertType),
              _detailRow('알림 메시지', data.alertMessage),
              _detailRow('내부 온도', '${data.internalTemperature}°C'),
              _detailRow('내부 습도', '${data.internalHumidity}%'),
              _detailRow('온도 변화율', '${data.temperatureDiff}%'),
              _detailRow('습도 변화율', '${data.humidityDiff}%'),
              _detailRow('뚜껑 상태', data.doorStatus),
              _detailRow('배터리 존재', data.batteryExists ? '있음' : '없음'),
              _detailRow('부저 상태', data.beepStatus ? 'ON' : 'OFF'),
              _detailRow('조명 상태', data.lightStatus ? 'ON' : 'OFF'),
            ],
          );
        },
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Flexible(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

// 5. 앱 시작점
void main() {
  runApp(const MyApp());
}


