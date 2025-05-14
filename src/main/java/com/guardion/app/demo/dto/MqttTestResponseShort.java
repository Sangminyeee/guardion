package com.guardion.app.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class MqttTestResponseShort {
	private String topic;
	private String message;
}
