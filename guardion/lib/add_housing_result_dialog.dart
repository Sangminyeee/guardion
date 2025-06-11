import 'package:flutter/material.dart';

Future<void> showResultDialog(
  BuildContext context, {
  required bool isSuccess,
  required String serialNumber,
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
                        TextSpan(text: isSuccess ? '의 등록이 ' : '의 등록이 '),
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
                            onPressed: () {
                              // TODO: 성공 시 계속 등록, 실패 시 재시도 로직 추가
                              Navigator.pop(context);
                            },
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
                            onPressed: () {
                              // TODO: 홈으로 이동 로직 추가
                              Navigator.pop(context);
                            },
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
