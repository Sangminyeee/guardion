package com.guardion.app.demo.mqtt;

import java.nio.charset.StandardCharsets;

import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.converter.DeviceDataConverter;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.mqtt.MqttTestRequestDetailed;
import com.guardion.app.demo.dto.mqtt.MqttTestRequestDetailed2;
import com.guardion.app.demo.repository.DeviceDataRepository;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class MqttSubscriber implements MqttCallback {

	private final DeviceDataConverter deviceDataConverter;
	private final DeviceDataRepository deviceDataRepository;

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
			client.subscribe("containers/+/metrics");

		} catch (MqttException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void connectionLost(Throwable cause) {
		System.out.println("Connection lost: " + cause.getMessage());
	}

	@Override
	public void messageArrived(String topic, MqttMessage message) {
		System.out.println("Received message:");
		System.out.println("Topic: " + topic);
		System.out.println("Message: " + new String(message.getPayload()));

		String payload = new String(message.getPayload(), StandardCharsets.UTF_8);

		ObjectMapper objectMapper = new ObjectMapper();
		MqttTestRequestDetailed2 mqttData = null;
		try {
			mqttData = objectMapper.readValue(payload, MqttTestRequestDetailed2.class);
			// DeviceData entity = dto.toEntity();
			DeviceData entity = deviceDataConverter.mqttTestRequestDetailed2ToDeviceData(mqttData);
			deviceDataRepository.save(entity);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken token) {
		// Not used for subscriber
	}
}
