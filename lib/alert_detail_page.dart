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

// AlertDetail 모델 클래스 추가
class AlertDetail {
  final String deviceSerialNumber;
  final String alertTime;
  final String alertType;
  final String alertMessage;

  AlertDetail({
    required this.deviceSerialNumber,
    required this.alertTime,
    required this.alertType,
    required this.alertMessage,
  });

  factory AlertDetail.fromJson(Map<String, dynamic> json) {
    return AlertDetail(
      deviceSerialNumber: json['deviceSerialNumber'] ?? '',
      alertTime: json['alertTime'] ?? '',
      alertType: json['alertType'] ?? '',
      alertMessage: json['alertMessage'] ?? '',
    );
  }
}

class AlertDetailPage extends StatefulWidget {
  final int alertId;
  const AlertDetailPage({super.key, required this.alertId});

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  AlertDetail? alertDetail;
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchAlertDetail();
  }

  Future<void> _fetchAlertDetail() async {
    try {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'jwt_token');
      if (token == null) {
        setState(() {
          errorMsg = '로그인 토큰이 없습니다.';
          isLoading = false;
        });
        return;
      }
      final url = Uri.parse('http://3.39.253.151:8080/alert/${widget.alertId}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          setState(() {
            alertDetail = AlertDetail.fromJson(jsonBody['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMsg = '데이터가 없습니다.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMsg = '서버 오류: ${response.statusCode}';
          isLoading = false;
        });
        print('❌ 서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMsg = '예외 발생: $e';
        isLoading = false;
      });
      print('❌ 예외 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 상세')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMsg != null
              ? Center(child: Text(errorMsg!, textAlign: TextAlign.center))
              : alertDetail == null
              ? const Center(child: Text('데이터가 없습니다.'))
              : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _dataRow('시리얼넘버', alertDetail!.deviceSerialNumber),
                  _dataRow('알림 시각', alertDetail!.alertTime),
                  _dataRow('알림 종류', alertDetail!.alertType),
                  _dataRow('알림 메시지', alertDetail!.alertMessage),
                ],
              ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
      home: const AlertDetailPage(alertId: 1), // 테스트용 알림 ID
    );
  }
}
