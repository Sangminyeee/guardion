package com.guardion.app.demo.mqtt;

import java.nio.charset.StandardCharsets;

import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.converter.DeviceDataConverter;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.mqtt.MqttTestRequest;
import com.guardion.app.demo.dto.mqtt.MqttTestRequestDetailed;
import com.guardion.app.demo.repository.DeviceDataRepository;
import com.guardion.app.demo.sse.SseController;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class MqttMessageHandler {

	private final DeviceDataRepository deviceDataRepository;
	private final DeviceDataConverter deviceDataConverter;
	private final SseController sseController;

	@Transactional
	public void messageArrived(String topic, MqttMessage message) { //테스트용
		String payload = new String(message.getPayload(), StandardCharsets.UTF_8);
		System.out.println("Received: " + message);

		// 예: JSON 형식일 경우 처리
		ObjectMapper objectMapper = new ObjectMapper();
		MqttTestRequestDetailed mqttData = null;
		try {
			mqttData = objectMapper.readValue(payload, MqttTestRequestDetailed.class);
			// DeviceData entity = dto.toEntity();
			DeviceData entity = deviceDataConverter.mqttTestRequestDetailedToDeviceData(mqttData);
			deviceDataRepository.save(entity);
		} catch (Exception e) {
			e.printStackTrace();
		}

		// sseController.sendSensorDataToClients(mqttData);
	}
}
