package com.guardion.app.demo.mqtt;

import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.dto.mqtt.MqttTestSend;
import com.guardion.app.demo.dto.mqtt.MqttTestSendShort;
import com.guardion.app.demo.exception.responseDto.ApiResponse;

@RestController
@RequiredArgsConstructor
@RequestMapping("/control")
public class MqttPublishController {

	private final MqttPublisher mqttPublisher;
	private final ObjectMapper objectMapper;

	@PostMapping("/device")
	public ResponseEntity<ApiResponse<String>> sendMqtt(@RequestBody MqttTestSend request) throws Exception {
		String topic = "devices/batsafety/control";
		String payload = objectMapper.writeValueAsString(request);

		mqttPublisher.publish(topic, payload);
		String result = "Published to topic: " + topic + " with payload: " + payload;

		return ResponseEntity.ok(ApiResponse.success(result));
	}
}
