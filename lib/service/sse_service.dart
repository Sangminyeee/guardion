import "package:eventsource/eventsource.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SseService {
  static const String _sseUrl = 'http://3.39.253.151:8080/sse/subscribe';
  static final _storage = const FlutterSecureStorage();

  static Future<void> listen(void Function(String) onMessage) async {
    final token = await _storage.read(key: 'jwt_token');
    final eventSource = await EventSource.connect(
      _sseUrl,
      headers: {'Authorization': 'Bearer $token'},
    );
    eventSource.listen((event) {
      if (event.event == 'sensor-data' && event.data != null) {
        onMessage(event.data!);
      }
    });
  }
}