import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  String institutionCode = '';
  String username = '';
  String password = '';
  String confirmPassword = '';

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
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),

                // ✅ 바디 상단 로고 추가
                Center(
                  child: Image.asset(
                    'assets/images/guardion_logo.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) =>
                        Text('이미지 로딩 실패'),
                  ),
                ),
                SizedBox(height: 20),

                Text(
                  '서비스를 이용하시려면 회원가입을 해주세요.',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                SizedBox(height: 40),

                // 기관 코드
                _buildTextField(
                  label: '기관 코드',
                  onChanged: (val) => institutionCode = val,
                  validator: (val) =>
                  val == null || val.isEmpty ? '기관 코드를 입력해주세요' : null,
                ),
                SizedBox(height: 16),

                // 사용자 이름
                _buildTextField(
                  label: '사용자 이름',
                  onChanged: (val) => username = val,
                  validator: (val) =>
                  val == null || val.isEmpty ? '사용자 이름을 입력해주세요' : null,
                ),
                SizedBox(height: 16),

                // 비밀번호
                _buildTextField(
                  label: '비밀번호',
                  obscureText: true,
                  onChanged: (val) => password = val,
                  validator: (val) =>
                  val == null || val.isEmpty ? '비밀번호를 입력해주세요' : null,
                ),
                SizedBox(height: 16),

                // 비밀번호 확인
                _buildTextField(
                  label: '비밀번호 확인',
                  obscureText: true,
                  onChanged: (val) => confirmPassword = val,
                  validator: (val) {
                    if (val == null || val.isEmpty) return '비밀번호 확인을 입력해주세요';
                    if (val != password) return '비밀번호가 일치하지 않습니다';
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // 회원가입 버튼
                ElevatedButton(
                  onPressed: _handleSignup,
                  child: Text('회원가입'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),

                // 로그인 이동 버튼
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: Text('이미 계정이 있으신가요? 로그인'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.lightBlue[100],
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('회원가입이 완료되었습니다!', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('로그인 화면으로 돌아가기'),
              ),
            ],
          ),
        ),
      );
    }
  }
}