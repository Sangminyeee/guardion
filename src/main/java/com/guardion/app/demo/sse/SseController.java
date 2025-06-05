package com.guardion.app.demo.sse;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.guardion.app.demo.dto.alert.SseSendAlert;
import com.guardion.app.demo.dto.mqtt.SensorData;

@RestController
@RequestMapping("/sse")
public class SseController {

	// 클라이언트별로 emitter 저장
	private final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();

	@GetMapping(value = "/data-alert", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	public SseEmitter subscribe() {
		SseEmitter emitter = new SseEmitter(Long.MAX_VALUE); // 연결 지속 시간
		emitters.add(emitter);

		// 연결 끊기면 emitter 제거
		emitter.onCompletion(() -> emitters.remove(emitter));
		emitter.onTimeout(() -> emitters.remove(emitter));

		// System.out.println("클라이언트 SSE 구독 요청 들어옴");
		return emitter;
	}

	// 센서 데이터가 수신될 때 이 메서드를 호출한다고 가정
	public void sendSensorDataToClients(SensorData data) {
		for (SseEmitter emitter : emitters) {
			try {
				emitter.send(SseEmitter.event()
					.name("sensor-data")
					.data(data));
			} catch (Exception e) {
				emitters.remove(emitter); // 끊어진 emitter 제거
			}
		}
		// System.out.println("현재 연결된 emitter 수: " + emitters.size());
	}

	// 알림 쏘기
	public void sendAlertToClients(SseSendAlert data) {
		for (SseEmitter emitter : emitters) {
			try {
				emitter.send(SseEmitter.event()
					.name("alert-data")
					.data(data));
			} catch (Exception e) {
				emitters.remove(emitter); // 끊어진 emitter 제거
			}
		}
		// System.out.println("현재 연결된 emitter 수: " + emitters.size());
	}
}
