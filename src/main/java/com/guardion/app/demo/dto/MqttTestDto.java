package com.guardion.app.demo.dto;

import com.guardion.app.demo.domain.DeviceData;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Getter
@NoArgsConstructor
public class MqttTestDto {
	private Long deviceId;
	private Float message;
}
