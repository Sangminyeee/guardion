package com.guardion.app.demo.mqtt;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.dto.mqtt.MqttControlRequest;
import com.guardion.app.demo.exception.responseDto.ApiResponse;

@Tag(name = "임계값 설정 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/control")
public class MqttPublishController {

	private final MqttPublisher mqttPublisher;
	private final ObjectMapper objectMapper;

	@Operation(summary = "사용자 임계값 POST API", description = "임계값 설정 시")
	@PostMapping("/device")
	public ResponseEntity<ApiResponse<String>> sendMqtt(@RequestBody MqttControlRequest request) throws Exception {
		String topic = "devices/" + request.getDeviceId() + "/control";
		String payload = objectMapper.writeValueAsString(request);

		mqttPublisher.publish(topic, payload);
		String result = "Published to topic: " + topic + " with payload: " + payload;

		return ResponseEntity.ok(ApiResponse.success(result));
	}
}
