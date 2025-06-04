import 'package:flutter/material.dart';
import 'add_housing_page.dart';
import 'housing_detail_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final url = Uri.parse(
    'http://3.39.253.151:8080/device-data/temperature-humidity/$serialNumber',
  );

  if (globalToken == null) {
    print('토큰이 없습니다. 로그인부터 하세요!');
    return null;
  }

  print('[API REQUEST] GET $url');
  print('사용할 토큰: $globalToken');

  final response = await http.get(
    url,
    headers: {
      'Authorization': globalToken!,
    },
  );

  print('[API RESPONSE] statusCode: ${response.statusCode}');
  print('[API RESPONSE] body: ${response.body}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> res = json.decode(response.body);
    if (res['success'] == true && res['data'] != null) {
      return TempHumidityData.fromJson(res['data']);
    }
  }
  return null;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> serialNumbers = ['A', 'B', 'C'];
  String selectedSerial = 'A';
  @override
  void initState() {
    super.initState();
    _loadTempHumidity(selectedSerial);
  }


  final List<Map<String, String>> alerts = [
    {'serial': 'AX0132F', 'time': '2025.05.10 20:44', 'msg': '고온 경고'},
    {'serial': 'BX8831D', 'time': '2025.05.10 19:31', 'msg': '습도 정상'},
    {'serial': 'AX0132F', 'time': '2025.05.09 18:10', 'msg': '저온 경고'},
    {'serial': 'ZX0192P', 'time': '2025.05.08 14:22', 'msg': '배터리 교체 필요'},
  ];

  TempHumidityData? tempHumidityData;
  bool isLoadingTempHumidity = false;

// 페이지 진입 및 시리얼넘버 변경 시 호출
  void _loadTempHumidity(String serialNumber) async {
    setState(() {
      isLoadingTempHumidity = true;
    });
    final data = await fetchTempHumidity(serialNumber);

    setState(() {
      tempHumidityData = data;
      isLoadingTempHumidity = false;
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/BSMS_Logo_TPBG.png', width: 40),
            const SizedBox(width: 12),
            const Text(
              'GUARDION',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 180,
                child: Image.asset(
                  'assets/images/BSMS_Logo_TPBG.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '대시보드',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A9E0),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedSerial,
              items: serialNumbers.map((serial) => DropdownMenuItem(
                value: serial,
                child: Text(serial),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSerial = value;
                  });
                  _loadTempHumidity(value);

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              HousingDetailPage(serialNumber: selectedSerial),
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
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
                        alert['msg']!.contains('정상')
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '[${alert['serial']}] ${alert['time']} - ${alert['msg']}',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    alert['msg']!.contains('정상')
                                        ? const Color(0xFF00A9E0)
                                        : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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
