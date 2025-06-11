import 'package:flutter/material.dart';
import 'add_housing_page.dart';
import 'housing_detail_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service/sse_service.dart' as sse;
import 'service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_page.dart';

// 온도/습도 데이터 모델
class TempHumidityData {
  final double temperature;
  final double humidity;

  TempHumidityData({required this.temperature, required this.humidity});

  factory TempHumidityData.fromJson(Map<String, dynamic> json) {
    return TempHumidityData(
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
    );
  }
}

// API 요청 함수
Future<TempHumidityData?> fetchTempHumidity(String serialNumber) async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'jwt_token');
  print('[DEBUG] fetchTempHumidity 사용할 토큰: $token');
  if (token == null) {
    print('❌ 토큰이 없습니다. 로그인 필요.');
    return null;
  }
  final url = Uri.parse(
    'http://3.39.253.151:8080/device-data/temperature-humidity/$serialNumber',
  );
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
      await storage.delete(key: 'jwt_token');
      // 로그아웃 처리 필요시 Navigator 등 활용
      return null;
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> res = json.decode(response.body);
      if (res['success'] == true && res['data'] != null) {
        return TempHumidityData.fromJson(res['data']);
      }
    }
    return null;
  } catch (e) {
    print('❌ 예외 발생: $e');
    return null;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> housingList = [];
  String? selectedSerial;
  List<dynamic> alerts = [];
  TempHumidityData? tempHumidityData;
  bool isLoadingTempHumidity = false;
  bool isLoadingAlerts = false;
  bool isLoadingHousings = false;

  @override
  void initState() {
    super.initState();
    _loadHousings();
    sse.SseService.listen((data) {
      _loadAlerts();
    });
  }

  Future<void> _loadHousings() async {
    setState(() {
      isLoadingHousings = true;
    });
    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'jwt_token');
      print('[DEBUG] _loadHousings 사용할 토큰: $token');
      final result = await ApiService.getUserDevices();
      print('housingList: $result');
      setState(() {
        housingList = result ?? [];
        if (housingList.isNotEmpty) {
          selectedSerial = housingList[0]['serialNumber']?.toString();
        } else {
          selectedSerial = null;
        }
      });
      _loadAll(selectedSerial);
    } catch (e) {
      print('함체 불러오기 실패: $e');
      setState(() {
        housingList = [];
        selectedSerial = null;
      });
    }
    setState(() {
      isLoadingHousings = false;
    });
  }

  void _loadAll(String? serial) {
    if (serial != null) {
      _loadTempHumidity(serial);
      _loadAlerts();
    }
  }

  void _loadTempHumidity(String serialNumber) async {
    setState(() {
      isLoadingTempHumidity = true;
    });
    try {
      final result = await ApiService.getTemperatureHumidity(serialNumber);
      setState(() {
        tempHumidityData =
            (result != null)
                ? TempHumidityData(
                  temperature: (result['temperature'] ?? 0).toDouble(),
                  humidity: (result['humidity'] ?? 0).toDouble(),
                )
                : null;
      });
    } catch (e) {
      setState(() {
        tempHumidityData = null;
      });
    } finally {
      setState(() {
        isLoadingTempHumidity = false;
      });
    }
  }

  void _loadAlerts() async {
    setState(() {
      isLoadingAlerts = true;
    });
    try {
      final result = await ApiService.getAlerts();
      setState(() {
        alerts = result ?? [];
      });
    } catch (e) {
      setState(() {
        alerts = [];
      });
    } finally {
      setState(() {
        isLoadingAlerts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'GUARDION',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                '함체 대시보드',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00A9E0),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButton<String>(
                value: selectedSerial,
                items:
                    housingList
                        .map(
                          (housing) => DropdownMenuItem(
                            value: housing['serialNumber']?.toString(),
                            child: Text(
                              '${housing['serialNumber'] ?? ''} (${housing['deviceName'] ?? '이름없음'})',
                            ),
                          ),
                        )
                        .toList(),
                onChanged:
                    (housingList.isEmpty)
                        ? null
                        : (value) {
                          if (value != null) {
                            setState(() {
                              selectedSerial = value;
                            });
                            _loadAll(value);
                          }
                        },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF00A9E0), width: 2),
                  ),
                  onPressed:
                      (selectedSerial == null)
                          ? null
                          : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HousingDetailPage(
                                      serialNumber: selectedSerial!,
                                    ),
                              ),
                            );
                          },
                  child: const Text(
                    '함체 데이터 상세보기',
                    style: TextStyle(
                      color: Color(0xFF00A9E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (housingList.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '등록된 함체가 없습니다. 우측 하단 + 버튼으로 함체를 등록해 주세요.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (housingList.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Column(
                          children: [
                            const Text('온도'),
                            isLoadingTempHumidity
                                ? const CircularProgressIndicator()
                                : Text(
                                  tempHumidityData != null
                                      ? '${tempHumidityData!.temperature}°C'
                                      : '-',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Column(
                          children: [
                            const Text('습도'),
                            isLoadingTempHumidity
                                ? const CircularProgressIndicator()
                                : Text(
                                  tempHumidityData != null
                                      ? '${tempHumidityData!.humidity}%'
                                      : '-',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00A9E0),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  '알림센터',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A9E0),
                  ),
                ),
                const SizedBox(height: 12),
                if (alerts.isEmpty)
                  const Text('알림이 없습니다.', style: TextStyle(color: Colors.grey)),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: isLoadingAlerts ? 0 : alerts.length,
                  separatorBuilder: (context, idx) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final alert = alerts[idx];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/alertDetail',
                          arguments: {
                            'alert': alert,
                            'serialNumber': selectedSerial,
                          },
                        );
                      },
                      child: Card(
                        color:
                            alert['msg']?.toString().contains('정상') == true
                                ? const Color(0xFFE6F7FD)
                                : const Color(0xFFFFD6D6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...alert.keys
                                  .map((k) => Text('$k: ${alert[k]}'))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHousingPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
