package com.guardion.app.demo.mqtt;

import java.nio.charset.StandardCharsets;

import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.converter.DeviceDataConverter;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.MqttTestDto;
import com.guardion.app.demo.repository.DeviceDataRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class MqttMessageHandler {

	private final DeviceDataRepository deviceDataRepository;
	private final DeviceDataConverter deviceDataConverter;

	public void messageArrived(String topic, MqttMessage message) {
		String payload = new String(message.getPayload(), StandardCharsets.UTF_8);
		System.out.println("Received: " + payload);

		// 예: JSON 형식일 경우 처리
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			MqttTestDto dto = objectMapper.readValue(payload, MqttTestDto.class);
			// DeviceData entity = dto.toEntity();
			DeviceData entity = deviceDataConverter.mqttTestDtoToDeviceData(dto);
			deviceDataRepository.save(entity);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
