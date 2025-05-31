import 'package:flutter/material.dart';

class AlertDetailPage extends StatelessWidget {
  const AlertDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> alert =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final isNormal = alert['msg']!.contains('정상');
    final cardColor =
        isNormal ? const Color(0xFFE6F7FD) : const Color(0xFFFFD6D6);
    final valueColor = isNormal ? const Color(0xFF00A9E0) : Colors.red;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '알림 상세',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Card(
          color: cardColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '알림 시간',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  alert['time'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  '알림 내용',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  alert['msg'] ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                if (!isNormal) ...[
                  const SizedBox(height: 32),
                  const Text(
                    '조치 안내',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getActionGuide(alert['msg'] ?? ''),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getActionGuide(String msg) {
    if (msg.contains('고온')) return '온도가 높으니 즉시 확인 바랍니다.';
    if (msg.contains('저온')) return '온도가 낮으니 보온 조치를 해주세요.';
    if (msg.contains('배터리')) return '배터리 교체가 필요합니다.';
    return '상세 내용을 확인하세요.';
  }
}
