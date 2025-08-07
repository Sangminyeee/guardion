package com.guardion.app.demo.mqtt;

import java.nio.charset.StandardCharsets;

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
public class MqttSubscriber implements MqttCallback {

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

	@PostConstruct
	public void subscribe() {
		try {
			client = new MqttClient(broker, clientId, new MemoryPersistence());
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
		SensorData mqttData = null;
		DeviceData deviceData = null;

		try {
			mqttData = objectMapper.readValue(payload, SensorData.class);
		} catch (Exception e) {
			System.out.println("Error processing MQTT message : " + e.getMessage());
			e.printStackTrace();
		}

		deviceData = deviceDataConverter.sensorDataToDeviceData(mqttData);
		deviceDataRepository.save(deviceData);
		if(!deviceData.getState().toString().equals("NORMAL")) {
			System.out.println("Alert condition met: " + deviceData.getState().toString());
			shouldAlert = true;
		}

		sseController.sendSensorDataToClients(mqttData);
		System.out.println("Sensor data sent to SSE clients : " + mqttData.getContainer());

		if(shouldAlert) {
			System.out.println("Sending alert for device: " + deviceData.getDevice().getId());
			Alert alert = alertConverter.deviceDataToAlert(deviceData);
			alertRepository.save(alert);
			//sse 송신용 dto 로 변경
			SseSendAlert data = sseConverter.deviceDataToSseSendAlert(deviceData);
			sseController.sendAlertToClients(data);
			System.out.println("Alert sent to SSE clients: " + alert.getId());
		}
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {
		// Not used for subscriber
	}
}
