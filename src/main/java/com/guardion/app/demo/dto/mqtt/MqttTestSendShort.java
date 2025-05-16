package com.guardion.app.demo.dto.mqtt;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class MqttTestSendShort {
	private String topic;
	private String message;
}
