import "package:eventsource/eventsource.dart";
import 'package:guardion/auth_manager.dart';

class SseService {
  static const String _sseUrl = 'http://3.39.253.151:8080/sse/subscribe';

  static Future<void> listen(void Function(String) onMessage) async {
    final token = await AuthManager.getToken();
    print('[DEBUG] SSE 연결에 사용할 토큰: $token');
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
