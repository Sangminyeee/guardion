package com.guardion.app.demo.mqtt;

import java.nio.charset.StandardCharsets;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.converter.AlertConverter;
import com.guardion.app.demo.converter.DeviceDataConverter;
import com.guardion.app.demo.converter.SseConverter;
import com.guardion.app.demo.domain.Alert;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.alert.SseSendAlert;
import com.guardion.app.demo.dto.mqtt.SensorData;
import com.guardion.app.demo.repository.AlertRepository;
import com.guardion.app.demo.repository.DeviceDataRepository;
import com.guardion.app.demo.sse.SseController;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class MqttSubscriber implements MqttCallbackExtended {

	private final DeviceDataConverter deviceDataConverter;
	private final DeviceDataRepository deviceDataRepository;
	private final AlertRepository alertRepository;
	private final SseController sseController;
	private final AlertConverter alertConverter;
	private final SseConverter sseConverter;

	@Value("${mqtt.broker}")
	private String broker; // MQTT 브로커 주소

	@Value("${mqtt.client-id}")
	private String clientId;

	private MqttClient client;

	private static final String TOPIC = "devices/+/data";
	private static final int QOS = 1;

	private final ScheduledExecutorService reconnectScheduler = Executors.newSingleThreadScheduledExecutor();
	private final AtomicInteger reconnectAttempts = new AtomicInteger(0);


	@PostConstruct
	public void subscribe() {
		connectAndSubscribe();
	}

	private void connectAndSubscribe() {
		try {
			if (client == null) {
				client = new MqttClient(broker, clientId, new MemoryPersistence());
			}
			MqttConnectOptions options = new MqttConnectOptions();
			options.setAutomaticReconnect(true);
			options.setCleanSession(false); // 재연결 시 구독 유지
			options.setConnectionTimeout(10);
			options.setKeepAliveInterval(20);
			client.setCallback(this);

			// LWT 설정 (선택)
			options.setWill("system/clients/" + clientId + "/state", "OFFLINE".getBytes(StandardCharsets.UTF_8), 1, true);

			if (!client.isConnected()) {
				client.connect(options);
			}

			// 구독 보장
			client.subscribe(TOPIC, QOS);
			reconnectAttempts.set(0); // 성공 시 초기화
			System.out.println("[MQTT] Connected & subscribed to '" + TOPIC + "' with QoS=" + QOS);
		} catch (MqttException e) {
			System.out.println("[MQTT] Initial connect/subscribe failed: " + e.getMessage());
			scheduleReconnect();
		}
	}

	private void scheduleReconnect() {
		int attempt = reconnectAttempts.incrementAndGet();
		long delaySec = Math.min(60, 1L << Math.min(10, attempt)); // 1,2,4,8,..., cap 60s
		System.out.println("[MQTT] Scheduling reconnect attempt " + attempt + " in " + delaySec + "s");
		reconnectScheduler.schedule(() -> {
			try {
				connectAndSubscribe();
			} catch (Exception ex) {
				System.out.println("[MQTT] Reconnect attempt " + attempt + " failed: " + ex.getMessage());
				scheduleReconnect();
			}
		}, delaySec, TimeUnit.SECONDS);
	}

	@Override
	public void connectionLost(Throwable cause) {
		System.out.println("[MQTT] Connection lost: " + (cause != null ? cause.getMessage() : "unknown"));
		scheduleReconnect();
	}

	@Override
	public void connectComplete(boolean reconnect, String serverURI) {
		System.out.println("[MQTT] connectComplete(reconnect=" + reconnect + ") to " + serverURI);
		try {
			// 재연결 시점에도 구독을 한 번 더 보장
			if (client != null && client.isConnected()) {
				client.subscribe(TOPIC, QOS);
				reconnectAttempts.set(0);
			}
		} catch (MqttException e) {
			System.out.println("[MQTT] connectComplete subscribe failed: " + e.getMessage());
			scheduleReconnect();
		}
	}

	@Override
	@Transactional
	public void messageArrived(String topic, MqttMessage message) {
		boolean shouldAlert = false;

		System.out.println("[MQTT] Received message:");
		System.out.println("[MQTT] Topic: " + topic);
		System.out.println("[MQTT] Message: " + new String(message.getPayload()));

		String payload = new String(message.getPayload(), StandardCharsets.UTF_8);

		ObjectMapper objectMapper = new ObjectMapper();
		SensorData mqttData = null;
		DeviceData deviceData = null;

		try {
			mqttData = objectMapper.readValue(payload, SensorData.class);
		} catch (Exception e) {
			System.out.println("[MQTT] Error processing MQTT message : " + e.getMessage());
			e.printStackTrace();
			return;
		}

		if (mqttData == null) {
			System.out.println("[MQTT] Empty MQTT data after parsing");
			return;
		}

		deviceData = deviceDataConverter.sensorDataToDeviceData(mqttData);
		deviceDataRepository.save(deviceData);
		if(!deviceData.getState().toString().equals("NORMAL")) {
			System.out.println("[MQTT] Alert condition met: " + deviceData.getState().toString());
			shouldAlert = true;
		}

		sseController.sendSensorDataToClients(mqttData);
		System.out.println("[MQTT] Sensor data sent to SSE clients : " + mqttData.getContainer());

		if(shouldAlert) {
			System.out.println("[MQTT] Sending alert for device: " + deviceData.getDevice().getId());
			Alert alert = alertConverter.deviceDataToAlert(deviceData);
			alertRepository.save(alert);
			//sse 송신용 dto 로 변경
			SseSendAlert data = sseConverter.deviceDataToSseSendAlert(deviceData);
			sseController.sendAlertToClients(data);
			System.out.println("[MQTT] Alert sent to SSE clients: " + alert.getId());
		}
	}

	@jakarta.annotation.PreDestroy
	public void shutdown() {
		try {
			if (client != null && client.isConnected()) {
				client.disconnect();
			}
		} catch (MqttException e) {
			// ignore
		}
		reconnectScheduler.shutdownNow();
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {
		// Not used for subscriber
	}
}
