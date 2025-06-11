import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HousingDetail {
  final String serialNumber;
  HousingDetail({required this.serialNumber});
  factory HousingDetail.fromJson(Map<String, dynamic> json) {
    return HousingDetail(serialNumber: json['serialNumber'] ?? '');
  }
}

// 시리얼넘버로 GET 조회
Future<HousingDetail?> fetchHousingDetail(String serialNumber) async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'jwt_token');
  if (token == null) {
    print('❌ 토큰이 없습니다. 로그인 필요.');
    return null;
  }
  final url = Uri.parse('http://3.39.253.151:8080/device/$serialNumber');
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
        return HousingDetail.fromJson(res['data']);
      }
    }
    return null;
  } catch (e) {
    print('❌ 예외 발생: $e');
    return null;
  }
}

class AddHousingPage extends StatefulWidget {
  const AddHousingPage({super.key});

  @override
  State<AddHousingPage> createState() => _AddHousingPageState();
}

class _AddHousingPageState extends State<AddHousingPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  // GET 조회로 등록 가능 여부 판단
  Future<bool> verifySerialNumber(String serial) async {
    final detail = await fetchHousingDetail(serial);
    return detail != null;
  }

  void registerHousing() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt_token');
    final serial = _controller.text.trim();
    if (serial.isEmpty || token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('시리얼넘버 또는 인증정보가 누락되었습니다.')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://3.39.253.151:8080/housing/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"serialNumber": serial}),
      );
      print('✅ 상태코드: \\${response.statusCode}');
      print('✅ 응답내용: \\${response.body}');
      if (response.statusCode == 401) {
        await storage.delete(key: 'jwt_token');
        // 로그아웃 처리 필요시 Navigator 등 활용
        throw Exception('인증이 만료되었습니다. 다시 로그인 해주세요.');
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        _controller.clear();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('등록 성공!')));
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: const Text('등록 완료'),
                content: const Text('함체가 성공적으로 등록되었습니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 다이얼로그 닫기
                      Navigator.pop(context); // 홈으로 이동
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
        );
      } else {
        throw Exception('등록 실패: ${response.body}');
      }
    } catch (e) {
      print("❌ 등록 실패: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('등록 실패: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showConfirmDialog(String serialNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 3D 배터리 아이콘
                    Image.asset(
                      'assets/images/battery_3d.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    // 시리얼넘버
                    Text(
                      serialNumber,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A9E0),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 안내문구
                    const Text(
                      '위 시리얼넘버가 정말 맞으신가요?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // 등록 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27C2F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // 다이얼로그 닫기
                          registerHousing(); // 실제 등록 함수 호출
                        },
                        child: const Text(
                          '맞다면 등록하기',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 오른쪽 상단 닫기 버튼
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF00A9E0),
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                  tooltip: '닫기',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          '함체 등록',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              '함체 등록',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A9E0),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '소유하고 계신 배터리 함체의 '),
                  TextSpan(
                    text: '시리얼넘버',
                    style: TextStyle(
                      color: Color(0xFF00A9E0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '를 입력해주세요.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '배터리함체 시리얼넘버',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27C2F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed:
                    _isLoading
                        ? null
                        : () => _showConfirmDialog(_controller.text.trim()),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          '등록',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
