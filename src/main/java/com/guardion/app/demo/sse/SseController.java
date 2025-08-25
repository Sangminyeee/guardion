package com.guardion.app.demo.sse;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.guardion.app.demo.dto.alert.SseSendAlert;
import com.guardion.app.demo.dto.mqtt.SensorData;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.servlet.http.HttpServletResponse;

@Tag(name = "SSE API", description = "무시해주세요!")
@RestController
@RequestMapping("/sse")
public class SseController {

	// 클라이언트별로 emitter 저장
	private final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();

	// 주기적 keep-alive 전송용 스케줄러
	private final ScheduledExecutorService heartbeatScheduler = Executors.newSingleThreadScheduledExecutor();

	@GetMapping(value = "/data-alert", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	public SseEmitter subscribe(HttpServletResponse response) {
		// 프록시/브라우저 버퍼링 방지 및 캐시 방지 헤더
		response.setHeader("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("X-Accel-Buffering", "no"); // Nginx 사용 시 버퍼링 방지

		SseEmitter emitter = new SseEmitter(Long.MAX_VALUE); // 연결 지속 시간 무제한(서블릿 타임아웃은 별도 설정)
		emitters.add(emitter);

		// 연결 종료/타임아웃/에러 시 정리
		emitter.onCompletion(() -> emitters.remove(emitter)); // 정상 종료
		emitter.onTimeout(() -> { emitters.remove(emitter); emitter.complete(); }); // 타임아웃 시
		emitter.onError((ex) -> { emitters.remove(emitter); }); // 네트워크 끊김, 전송 예외 등 오류 발생 시

		try {
			// 구독 직후 초기 이벤트로 연결 및 클라이언트 자동 재연결 대기시간 지정
			emitter.send(SseEmitter.event()
				.id(String.valueOf(System.currentTimeMillis()))
				.name("connected")
				.reconnectTime(15000) // 끊어지면 15초 후 재연결
				.data("ok"));
		} catch (IOException ignored) { }

		return emitter;
	}

	@PostConstruct
	private void startHeartbeat() {
		// 300초마다 모든 구독자에게 주석(comment) 이벤트 전송 -> 클라이언트 리스너를 방해하지 않음
		heartbeatScheduler.scheduleAtFixedRate(() -> {
			for (SseEmitter emitter : emitters) {
				try {
					emitter.send(SseEmitter.event().comment("keepalive"));
				} catch (Exception e) {
					emitters.remove(emitter);
				}
			}
		}, 60, 300, TimeUnit.SECONDS);
	}

	@PreDestroy
	private void stopHeartbeat() {
		// 스케줄러 정상 종료 시도
		heartbeatScheduler.shutdown();
		try {
			if (!heartbeatScheduler.awaitTermination(5, TimeUnit.SECONDS)) {
				// 지정 시간 내 종료가 안 되면 강제 종료
				heartbeatScheduler.shutdownNow();
			}
		} catch (InterruptedException ie) {
			heartbeatScheduler.shutdownNow();
			Thread.currentThread().interrupt();
		}

		// 남아있는 SSE 연결 정리
		for (SseEmitter emitter : emitters) {
			try {
				emitter.complete();
			} catch (Exception ignored) { }
		}
	}

	// 센서 데이터가 수신될 때 이 메서드를 호출한다고 가정
	public void sendSensorDataToClients(SensorData data) {
		for (SseEmitter emitter : emitters) {
			try {
				emitter.send(SseEmitter.event()
					.name("sensor-data")
					.data(data));
			} catch (Exception e) {
				emitter.completeWithError(e);
				emitters.remove(emitter); // 끊어진 emitter 제거
			}
		}
		// System.out.println("현재 연결된 emitter 수: " + emitters.size());
	}

	// 알림 쏘기
	public void sendAlertToClients(SseSendAlert data, String comment) {
		for (SseEmitter emitter : emitters) {
			try {
				emitter.send(SseEmitter.event()
					.name("alert-data")
					.comment(comment)
					.data(data));
			} catch (Exception e) {
				emitter.completeWithError(e);
				emitters.remove(emitter); // 끊어진 emitter 제거
			}
		}
		// System.out.println("현재 연결된 emitter 수: " + emitters.size());
	}
}
