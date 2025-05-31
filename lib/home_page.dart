import 'package:flutter/material.dart';
import 'add_housing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> serialNumbers = ['AX0132F', 'BX8831D', 'ZX0192P'];
  String selectedSerial = 'AX0132F';

  final List<Map<String, String>> alerts = [
    {'time': '2025.05.10 20:44', 'msg': '고온 경고'},
    {'time': '2025.05.10 19:31', 'msg': '습도 정상'},
    {'time': '2025.05.09 18:10', 'msg': '저온 경고'},
    {'time': '2025.05.08 14:22', 'msg': '배터리 교체 필요'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 180,
                child: Image.asset(
                  'assets/images/guardion_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '대시보드',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A9E0),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedSerial,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              underline: Container(height: 2, color: Color(0xFF00A9E0)),
              items:
                  serialNumbers.map((serial) {
                    return DropdownMenuItem<String>(
                      value: serial,
                      child: Text(serial),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSerial = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF00A9E0), width: 2),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/housingDetail');
                },
                child: const Text(
                  '함체 데이터 상세보기',
                  style: TextStyle(
                    color: Color(0xFF00A9E0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      child: Column(
                        children: const [
                          Text(
                            '온도',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '25°C',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      child: Column(
                        children: const [
                          Text(
                            '습도',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '60%',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00A9E0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              '알림센터',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A9E0),
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
              separatorBuilder: (context, idx) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                final alert = alerts[idx];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/alertDetail',
                      arguments: alert,
                    );
                  },
                  child: Card(
                    color:
                        alert['msg']!.contains('정상')
                            ? const Color(0xFFE6F7FD)
                            : const Color(0xFFFFD6D6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${alert['time']} - ${alert['msg']}',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    alert['msg']!.contains('정상')
                                        ? const Color(0xFF00A9E0)
                                        : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHousingPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
