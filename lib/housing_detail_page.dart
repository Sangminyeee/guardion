import 'package:flutter/material.dart';

class HousingDetailPage extends StatelessWidget {
  final String serialNumber;
  const HousingDetailPage({super.key, this.serialNumber = 'AX0132F'});

  @override
  Widget build(BuildContext context) {
    final pastelBg = const Color(0xFFF7F7FF);
    return Scaffold(
      backgroundColor: pastelBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '함체 상세 정보',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFF00A9E0), width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
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
            _infoCard('현재 온도', '25°C', Colors.red),
            const SizedBox(height: 16),
            _infoCard('현재 습도', '60%', const Color(0xFF00A9E0)),
            const SizedBox(height: 16),
            _infoCard('온도 변화율', '+3%', Colors.orange),
            const SizedBox(height: 16),
            _infoCard('습도 변화율', '-5%', Colors.blueAccent),
            const SizedBox(height: 16),
            _infoCard('뚜껑 열림 여부', '닫힘', Colors.green),
            const SizedBox(height: 16),
            _infoCard('배터리 존재 여부', '있음', Colors.teal),
            const SizedBox(height: 16),
            _infoCard('알람 상태', '정상', Colors.purple),
            const SizedBox(height: 16),
            _infoCard('불빛 상태', '켜짐', const Color(0xFF00A9E0)),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, Color valueColor) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
