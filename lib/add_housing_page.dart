import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'service/api_service.dart';

class HousingDetail {
  final String serialNumber;
  HousingDetail({required this.serialNumber});
  factory HousingDetail.fromJson(Map<String, dynamic> json) {
    return HousingDetail(serialNumber: json['serialNumber'] ?? '');
  }
}

// 시리얼넘버로 GET 조회
Future<HousingDetail?> fetchHousingDetail(String serialNumber) async {
  final url = Uri.parse('http://3.39.253.151:8080/device/$serialNumber');

  if (globalToken == null) {
    print('토큰이 없습니다. 로그인부터 하세요!');
    return null;
  }

  print('[API REQUEST] GET $url');
  print('사용할 토큰: $globalToken');

  final response = await http.get(
    url,
    headers: {'Authorization': globalToken!},
  );

  print('[API RESPONSE] statusCode: ${response.statusCode}');
  print('[API RESPONSE] body: ${response.body}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> res = json.decode(response.body);
    if (res['success'] == true && res['data'] != null) {
      return HousingDetail.fromJson(res['data']);
    }
  }
  return null;
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

  void _onConfirmPressed() async {
    final serial = _controller.text.trim();
    if (serial.isEmpty) return;

    setState(() => _isLoading = true);
    final isValid = await verifySerialNumber(serial);
    setState(() => _isLoading = false);

    if (isValid) {
      Navigator.pushNamed(context, '/verify');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('존재하지 않는 시리얼넘버입니다')));
    }
  }

  void _onRegisterPressed() async {
    final serial = _controller.text.trim();
    if (serial.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await ApiService.registerDevice({
        'serialNumber': serial,
        'location': '', // 위치 입력값이 있다면 여기에 추가
      });
      _controller.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('등록 성공!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('등록 실패: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
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
                onPressed: _isLoading ? null : _onRegisterPressed,
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