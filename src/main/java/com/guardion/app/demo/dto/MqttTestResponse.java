package com.guardion.app.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class MqttTestResponse {
	private Long deviceId;
	private String command;
	private Long value;
}
