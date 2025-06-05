package com.guardion.app.demo.mqtt;

import static com.guardion.app.demo.eunms.AlertSeverity.*;

import java.nio.charset.StandardCharsets;

import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.converter.DeviceDataConverter;
import com.guardion.app.demo.domain.Alert;
import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.dto.alert.SseSendAlert;
import com.guardion.app.demo.dto.mqtt.MqttTestRequestDetailed;
import com.guardion.app.demo.dto.mqtt.MqttTestRequestDetailed2;
import com.guardion.app.demo.repository.AlertRepository;
import com.guardion.app.demo.repository.DeviceDataRepository;
import com.guardion.app.demo.repository.DeviceRepository;
import com.guardion.app.demo.sse.SseController;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class MqttSubscriber implements MqttCallback {

	private final DeviceDataConverter deviceDataConverter;
	private final DeviceDataRepository deviceDataRepository;
	private final AlertRepository alertRepository;
	private final SseController sseController;
	private final DeviceRepository deviceRepository;

	@Value("${mqtt.broker}")
	private String BROKER; // MQTT 브로커 주소

	@Value("${mqtt.client-id}")
	private String CLIENT_ID;

	private MqttClient client;

	@PostConstruct
	public void subscribe() {
		try {
			client = new MqttClient(BROKER, CLIENT_ID, new MemoryPersistence());
			MqttConnectOptions options = new MqttConnectOptions();
			options.setCleanSession(true);
			client.setCallback(this);
			client.connect(options);

			// 와일드카드 구독
			client.subscribe("devices/+/data");

		} catch (MqttException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void connectionLost(Throwable cause) {
		System.out.println("Connection lost: " + cause.getMessage());
	}

	@Override
	@Transactional
	public void messageArrived(String topic, MqttMessage message) {
		boolean shouldAlert = false;
		System.out.println("Received message:");
		System.out.println("Topic: " + topic);
		System.out.println("Message: " + new String(message.getPayload()));

		String payload = new String(message.getPayload(), StandardCharsets.UTF_8);

		ObjectMapper objectMapper = new ObjectMapper();
		MqttTestRequestDetailed2 mqttData = null;

		DeviceData entity = null;
		try {
			mqttData = objectMapper.readValue(payload, MqttTestRequestDetailed2.class);
			// DeviceData entity = dto.toEntity();
			entity = deviceDataConverter.mqttTestRequestDetailed2ToDeviceData(mqttData);
			deviceDataRepository.save(entity);
			if(!entity.getState().toString().equals("NORMAL")) {
				System.out.println("Alert condition met: " + entity.getState().toString());
				shouldAlert = true;
			}
		} catch (Exception e) {
			System.out.println("Error processing MQTT message: " + e.getMessage());
			e.printStackTrace();
		}

		sseController.sendSensorDataToClients(mqttData);
		System.out.println("After sse controller");

		User user = entity.getDevice().getUser();
		System.out.println("userId: " + user.getUsername());

		if(shouldAlert) {
			System.out.println("Sending alert for device: " + entity.getDevice().getId());

			Alert alert = Alert.builder()
				.user(user)
				.device(entity.getDevice())
				.alertType(entity.getState().toString())
				.deviceData(entity)
				.message("Device state changed to " + entity.getState().toString())
				.build();

			//알림 dto 로 변경
			SseSendAlert data = SseSendAlert.builder()
				.deviceState(entity.getState().toString())
				.build();

			sseController.sendAlertToClients(data);
			System.out.println("Alert sent to SSE clients: " + data.getDeviceState());
			try {
				alertRepository.save(alert);
				System.out.println("Alert saved to repository: " + alert.getId());
			} catch (Exception e) {
				System.out.println("Failed to save alert: " + e.getMessage());
				e.printStackTrace();
			}
		}
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {
		// Not used for subscriber
	}
}
