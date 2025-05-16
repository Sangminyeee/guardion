package com.guardion.app.demo.dto.mqtt;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Getter
@NoArgsConstructor
public class MqttTestRequest {
	private Long deviceId;
	private Float message;
}
