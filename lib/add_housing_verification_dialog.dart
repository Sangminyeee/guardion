import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guardion/auth_manager.dart';

// 등록 결과 다이얼로그
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

// 실제 등록 API 연동 함수
Future<bool> registerSerialNumber(String serial) async {
  final token = await AuthManager.getToken();
  if (token == null) {
    print('❌ 토큰이 없습니다. 로그인 필요.');
    return false;
  }
  const String apiUrl = 'http://3.39.253.151:8080/device/registerDevice';
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

// 시리얼넘버 확인 다이얼로그
Future<void> showVerificationDialog(
  BuildContext context,
  String serialNumber, {
  required VoidCallback onRegisterSuccess,
  required VoidCallback onRegisterFail,
  required VoidCallback onHome,
}) {
  bool isLoading = false;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        '등록할 함체의 시리얼 넘버가 맞는지 확인해 주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        serialNumber,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00A9E0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '위 시리얼넘버가 정말 맞으신가요?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
                              isLoading
                                  ? null
                                  : () async {
                                    setState(() => isLoading = true);

                                    final isSuccess =
                                        await registerSerialNumber(
                                          serialNumber,
                                        );

                                    setState(() => isLoading = false);

                                    Navigator.pop(context); // 확인 다이얼로그 닫기

                                    // 결과 다이얼로그 띄우기
                                    await showResultDialog(
                                      context,
                                      isSuccess: isSuccess,
                                      serialNumber: serialNumber,
                                      onContinue: () {
                                        Navigator.pop(context);
                                        if (isSuccess) {
                                          onRegisterSuccess();
                                        } else {
                                          onRegisterFail();
                                        }
                                      },
                                      onHome: () {
                                        Navigator.pop(context);
                                        onHome();
                                      },
                                    );
                                  },
                          child:
                              isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    '맞다면 등록하기',
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
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF27C2F3),
                        size: 28,
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
    },
  );
}
