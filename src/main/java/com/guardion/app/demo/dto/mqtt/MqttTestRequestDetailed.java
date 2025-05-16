package com.guardion.app.demo.dto.mqtt;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class MqttTestRequestDetailed {
	private Long deviceId;
	private Float temperature;
	private Float humidity;
	private boolean door;
	private boolean battery;
	private boolean beep;
	private boolean light;
	private Float temperature_setting;
	private boolean beep_setting;
	private boolean light_setting;

	public MqttTestRequestDetailed() { //왜...?
		this.deviceId = null;
		this.temperature = null;
		this.humidity = null;
		this.door = false;
		this.battery = false;
		this.beep = false;
		this.light = false;
		this.temperature_setting = null;
		this.beep_setting = false;
		this.light_setting = false;
	}
}
