package com.guardion.app.demo.mqtt;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.guardion.app.demo.dto.mqtt.MqttTestSend;
import com.guardion.app.demo.dto.mqtt.MqttTestSendShort;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mqtt")
public class MqttPublishController {

	private final MqttPublisher mqttPublisher;
	private final ObjectMapper objectMapper;

	@PostMapping("/send")
	public String sendMqtt(@RequestBody MqttTestSend request) throws Exception {
		String topic = "devices/batsafety/control";
		String payload = objectMapper.writeValueAsString(request);

		mqttPublisher.publish(topic, payload);
		return "Published to topic: " + topic;
	}

	@PostMapping("/send-1")
	public String sendMqtt(@RequestBody MqttTestSendShort request) throws Exception {
		mqttPublisher.publish(request.getTopic(), request.getMessage());
		return "Published to topic: " + request.getTopic();
	}
}
