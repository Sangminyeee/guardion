import 'package:flutter/material.dart';

class AlertDetailPage extends StatelessWidget {
  const AlertDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Map<String, String> alert = args['alert'] as Map<String, String>;
    final String serialNumber = args['serialNumber'] ?? 'AX0132F';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상단 시리얼넘버 카드
            Container(
              margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFF00A9E0), width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code, color: Color(0xFF00A9E0)),
                      const SizedBox(width: 10),
                      Text(
                        '함체 일련번호: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        serialNumber,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF00A9E0),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    color: cardColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 36,
                        horizontal: 28,
                      ),
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
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          // 데이터 상세정보 추가
                          const Text(
                            '데이터 상세정보',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _dataDetailRow('현재 온도', '25°C', Colors.red),
                          _dataDetailRow('현재 습도', '60%', Color(0xFF00A9E0)),
                          _dataDetailRow('온도 변화율', '+3%', Colors.orange),
                          _dataDetailRow('습도 변화율', '-5%', Colors.blueAccent),
                          _dataDetailRow('뚜껑 열림 여부', '닫힘', Colors.green),
                          _dataDetailRow(
                            '배터리 존재 여부',
                            '있음',
                            Colors.teal,
                            titleFontSize: 13,
                          ),
                          _dataDetailRow('알람 상태', '정상', Colors.purple),
                          _dataDetailRow('불빛 상태', '켜짐', Color(0xFF00A9E0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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

  Widget _dataDetailRow(
    String title,
    String value,
    Color valueColor, {
    double titleFontSize = 15,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(fontSize: titleFontSize, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
