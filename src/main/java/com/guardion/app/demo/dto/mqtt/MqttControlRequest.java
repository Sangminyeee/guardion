package com.guardion.app.demo.dto.mqtt;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class MqttControlRequest {

	@JsonProperty("device_id")
	private Long deviceId;

	@JsonProperty("command")
	private String command;

	@JsonProperty("value")
	private double value;
}
