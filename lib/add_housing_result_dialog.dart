import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardion/auth_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '함체 등록',
      home: AddHousingPage(),
      routes: {'/home': (_) => const HomePage()},
    );
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

  Future<bool> registerSerialNumber(String serial) async {
    final token = await AuthManager.getToken();
    if (token == null) {
      print('❌ 토큰이 없습니다. 로그인 필요.');
      return false;
    }
    final String apiUrl = 'http://3.39.253.151:8080/device';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'serialNumber': serial}),
      );
      print('✅ 상태코드: \\${response.statusCode}');
      print('✅ 응답내용: \\${response.body}');
      if (response.statusCode == 401) {
        await AuthManager.clear();
        return false;
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true && (data['data'] as List).isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
      return false;
    }
  }

  void _onConfirmPressed() async {
    final serial = _controller.text.trim();
    if (serial.isEmpty) return;

    setState(() => _isLoading = true);
    final isSuccess = await registerSerialNumber(serial);
    setState(() => _isLoading = false);

    await showResultDialog(
      context,
      isSuccess: isSuccess,
      serialNumber: serial,
      onContinue: () {
        Navigator.pop(context); // 다이얼로그 닫기
        _controller.clear(); // 입력폼 초기화
      },
      onHome: () {
        Navigator.pop(context); // 다이얼로그 닫기
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
                onPressed: _isLoading ? null : _onConfirmPressed,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          '확인',
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

Future<void> showResultDialog(
  BuildContext context, {
  required bool isSuccess,
  required String serialNumber,
  required VoidCallback onContinue,
  required VoidCallback onHome,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(text: '함체 시리얼넘버 '),
                        TextSpan(
                          text: serialNumber,
                          style: const TextStyle(
                            color: Color(0xFF00A9E0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const TextSpan(text: '의 등록이 '),
                        TextSpan(
                          text: isSuccess ? '완료' : '실패',
                          style: TextStyle(
                            color:
                                isSuccess
                                    ? const Color(0xFF00A9E0)
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '되었습니다.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF27C2F3),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: onContinue,
                            child: Text(
                              isSuccess ? '계속 등록하기' : '다시 시도하기',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE6F7FD),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: onHome,
                            child: const Text(
                              '홈으로 이동',
                              style: TextStyle(
                                color: Color(0xFF27C2F3),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF27C2F3),
                    size: 26,
                  ),
                  onPressed: () => Navigator.pop(context),
                  tooltip: '닫기',
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 홈화면 데모용
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: const Center(child: Text('홈 화면입니다')),
    );
  }
}
