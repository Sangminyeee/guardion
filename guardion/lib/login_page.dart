import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/images/guardion_logo.png', width: 40),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // ✨ 중앙 로고
              Center(
                child: Image.asset(
                  'assets/images/guardion_logo.png',
                  width: 120,
                  height: 120,
                ),
              ),

              const SizedBox(height: 20),

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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) => email = value,
                validator: (value) =>
                value == null || value.isEmpty ? '이메일을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력 필드
              TextFormField(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                obscureText: true,
                onChanged: (value) => password = value,
                validator: (value) =>
                value == null || value.isEmpty ? '비밀번호를 입력해주세요.' : null,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (email == 'test@example.com' && password == '123456') {
                      Navigator.pushReplacementNamed(context, '/home'); // ✅ 홈페이지로 이동
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('이메일 또는 비밀번호가 올바르지 않습니다.')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        // TODO: ID/PW 찾기 페이지 연결
                      },
                      child: const Text('아이디/비밀번호 찾기'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'), // ✅ 회원가입 페이지로 이동
                      child: const Text('회원가입'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/home'), // ✅ 홈페이지로 이동
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      child: const Text('메인화면으로 가기'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
