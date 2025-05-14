package com.guardion.app.demo.mqtt;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.dto.MqttTestResponse;
import com.guardion.app.demo.dto.MqttTestResponseShort;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mqtt")
public class MqttTestController {

	private final MqttPublisher mqttPublisher;
	private final ObjectMapper objectMapper;

	@PostMapping("/send")
	public String sendMqtt(@RequestBody MqttTestResponse request) throws Exception {
		// String topic = "device/" + request.getDeviceId() + "/command";
		String topic = "devices/batsafety/control";
		String payload = objectMapper.writeValueAsString(request);

		mqttPublisher.publish(topic, payload);
		return "Published to topic: " + topic;
	}

	@PostMapping("/send-1")
	public String sendMqtt(@RequestBody MqttTestResponseShort request) throws Exception {
		mqttPublisher.publish(request.getTopic(), request.getMessage());
		return "Sent to topic: " + request.getTopic();
	}
}
