import 'package:flutter/material.dart';

class HousingDetailPage extends StatelessWidget {
  const HousingDetailPage({super.key});

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
