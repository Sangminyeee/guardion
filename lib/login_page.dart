import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guardion/auth_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool autoLogin = false;
  bool isLoading = false;
  final _storage = const FlutterSecureStorage();

  Future<String?> loginApi() async {
    final url = Uri.parse('http://3.39.253.151:8080/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": email, "password": password}),
      );
      print('✅ 상태코드: \\${response.statusCode}');
      print('✅ 응답내용: \\${response.body}');
      if (response.statusCode == 200) {
        final authHeader = response.headers['authorization'] ?? '';
        const prefix = 'Bearer ';
        final raw =
            authHeader.startsWith(prefix)
                ? authHeader.substring(prefix.length)
                : authHeader;
        if (raw.isEmpty) {
          throw Exception('⚠️  서버가 JWT를 보내지 않았습니다.');
        }
        await AuthManager.saveToken(raw);
        print('[DEBUG] saved token → $raw');
        return null;
      } else if (response.statusCode == 401) {
        print("❌ 로그인 실패 - 인증 실패: \\${response.body}");
        return '이메일 또는 비밀번호가 올바르지 않습니다.';
      } else {
        print("❌ 로그인 실패 - 서버 오류: \\${response.body}");
        return '서버 오류: \\${response.statusCode}';
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
      return '네트워크 연결에 실패했습니다. 인터넷 또는 서버 상태를 확인하세요.';
    }
  }

  // JWT 토큰에서 userId(sub) 추출 함수
  String? extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payloadMap = json.decode(payload);
      return payloadMap['sub']
          ?.toString(); // 실제 userId가 들어있는 키(sub, userId, username 등) 확인 필요
    } catch (e) {
      print('userId 추출 실패: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(
              height: 60,
              child: Image.asset(
                'assets/images/BSMS_Logo_TPBG.png',
                width: 110,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ✨ 중앙 로고
                LayoutBuilder(
                  builder: (context, constraints) {
                    final logoWidth = (constraints.maxWidth * 0.7).clamp(
                      220.0,
                      320.0,
                    );
                    return Center(
                      child: Image.asset(
                        'assets/images/BSMS_Logo_TPBG.png',
                        width: logoWidth,
                        height: logoWidth,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  '서비스를 이용하시려면 로그인 해주세요.',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                const SizedBox(height: 40),

                // 사용자 이름 입력 필드
                TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '사용자 이름',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) => email = value,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? '이메일을 입력해주세요.'
                              : null,
                ),
                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) => password = value,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? '비밀번호를 입력해주세요.'
                              : null,
                ),
                const SizedBox(height: 16),

                // 자동 로그인 체크박스
                Row(
                  children: [
                    Checkbox(
                      value: autoLogin,
                      onChanged: (bool? value) {
                        setState(() {
                          autoLogin = value ?? false;
                        });
                      },
                    ),
                    const Text('자동 로그인'),
                  ],
                ),
                const SizedBox(height: 20),

                // 로그인 버튼
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );

                      String? error = await loginApi();

                      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기

                      if (error == null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error)));
                      }
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 20),

                // 기타 버튼들
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/find-id-pw');
                        },
                        child: const Text('아이디/비밀번호 찾기'),
                      ),

                      TextButton(
                        onPressed:
                            () => Navigator.pushNamed(
                              context,
                              '/signup',
                            ), // ✅ 회원가입 페이지로 이동
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
