import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FindIdPwPage extends StatefulWidget {
  const FindIdPwPage({super.key});

  @override
  State<FindIdPwPage> createState() => _FindIdPwPageState();
}

class _FindIdPwPageState extends State<FindIdPwPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  bool isLoading = false;
  String resultMessage = '';

  // 비밀번호 찾기 API 호출 함수 (엔드포인트/파라미터는 실제 백엔드에 맞게 수정)
  Future<void> findPassword() async {
    setState(() {
      isLoading = true;
      resultMessage = '';
    });
    final url = Uri.parse('http://3.39.253.151:8080/find-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": username}),
      );
      print('✅ 상태코드: \\${response.statusCode}');
      print('✅ 응답내용: \\${response.body}');
      setState(() {
        isLoading = false;
        if (response.statusCode == 200) {
          resultMessage = '비밀번호 재설정 안내가 발송되었습니다.';
        } else {
          resultMessage = '정보를 찾을 수 없습니다. 입력한 정보를 확인하세요.';
        }
      });
    } catch (e) {
      print('❌ 예외 발생: $e');
      setState(() {
        isLoading = false;
        resultMessage = '네트워크 오류가 발생했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디/비밀번호 찾기'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '가입 시 등록한 사용자 이름(아이디)을 입력하세요.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '사용자 이름(아이디)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => username = value,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? '사용자 이름(아이디)를 입력하세요.'
                            : null,
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        findPassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('비밀번호 찾기'),
                  ),
              const SizedBox(height: 24),
              if (resultMessage.isNotEmpty)
                Text(
                  resultMessage,
                  style: TextStyle(
                    color:
                        resultMessage.contains('발송')
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
