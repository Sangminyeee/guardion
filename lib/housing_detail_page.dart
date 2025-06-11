import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'package:guardion/auth_manager.dart';
import 'service/api_service.dart';

// 1. 데이터 모델 정의
class HousingDetail {
  final double temperature;
  final double temperatureDiff;
  final double humidity;
  final double humidityDiff;
  final String door;

  HousingDetail({
    required this.temperature,
    required this.temperatureDiff,
    required this.humidity,
    required this.humidityDiff,
    required this.door,
  });

  factory HousingDetail.fromJson(Map<String, dynamic> json) {
    return HousingDetail(
      temperature: (json['temperature'] ?? 0).toDouble(),
      temperatureDiff: (json['temperatureDiff'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      humidityDiff: (json['humidityDiff'] ?? 0).toDouble(),
      door: json['door'] ?? '',
    );
  }
}

// 2. API 호출 함수
Future<HousingDetail?> fetchHousingDetail(String serialNumber) async {
  final token = await AuthManager.getToken();
  if (token == null) {
    print('❌ 토큰이 없습니다. 로그인 필요.');
    return null;
  }
  final url = Uri.parse('http://3.39.253.151:8080/device-data/$serialNumber');
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('✅ 상태코드: \\${response.statusCode}');
    print('✅ 응답내용: \\${response.body}');
    if (response.statusCode == 401) {
      await AuthManager.clear();
      // 로그아웃 처리 필요시 Navigator 등 활용
      return null;
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> res = json.decode(response.body);
      if (res['success'] == true && res['data'] != null) {
        return HousingDetail.fromJson(res['data']);
      }
    }
    return null;
  } catch (e) {
    print('❌ 예외 발생: $e');
    return null;
  }
}

// 3. 상세 페이지 위젯
class HousingDetailPage extends StatefulWidget {
  final String serialNumber;
  const HousingDetailPage({super.key, this.serialNumber = 'AX0132F'});

  @override
  State<HousingDetailPage> createState() => _HousingDetailPageState();
}

class _HousingDetailPageState extends State<HousingDetailPage> {
  HousingDetail? detail;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      isLoading = true;
    });
    final token = await AuthManager.getToken();
    if (widget.serialNumber.isEmpty || token == null) {
      setState(() {
        detail = null;
        isLoading = false;
      });
      return;
    }
    try {
      final result = await ApiService.getDeviceData(widget.serialNumber);
      setState(() {
        if (result != null) {
          detail = HousingDetail(
            temperature: (result['temperature'] ?? 0).toDouble(),
            temperatureDiff: (result['temperatureDiff'] ?? 0).toDouble(),
            humidity: (result['humidity'] ?? 0).toDouble(),
            humidityDiff: (result['humidityDiff'] ?? 0).toDouble(),
            door: result['door']?.toString() ?? '',
          );
        } else {
          detail = null;
        }
      });
    } catch (e) {
      setState(() {
        detail = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pastelBg = const Color(0xFFF7F7FF);
    return Scaffold(
      backgroundColor: pastelBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '함체 상세 정보',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : detail == null
                ? const Center(child: Text('데이터를 불러올 수 없습니다.'))
                : ListView(
                  children: [
                    _infoCard('온도', '${detail!.temperature}°C', Colors.red),
                    const SizedBox(height: 16),
                    _infoCard('습도', '${detail!.humidity}%', Colors.blue),
                    const SizedBox(height: 16),
                    _infoCard(
                      '온도 변화율',
                      '${detail!.temperatureDiff}%',
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    _infoCard(
                      '습도 변화율',
                      '${detail!.humidityDiff}%',
                      Colors.teal,
                    ),
                    const SizedBox(height: 16),
                    _infoCard(
                      '뚜껑 열림 여부',
                      detail!.door == 'OPEN' ? '열림' : '닫힘',
                      detail!.door == 'OPEN' ? Colors.green : Colors.grey,
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _infoCard(String title, String value, Color valueColor) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
