package com.guardion.app.demo.dto.mqtt;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class MqttTestSend {
	private Long deviceId;
	private String command;
	private Long value;
}
