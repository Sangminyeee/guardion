package com.guardion.app.demo.dto.mqtt;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SensorData {
	private String container;
	private double temp;
	private double hum;
	private double tempDiff;
	private double humDiff;
	private String door;
	private boolean battery;
	private String state;

	public SensorData() { // Default constructor
		this.container = null;
		this.temp = 0;
		this.hum = 0;
		this.tempDiff = 0;
		this.humDiff = 0;
		this.door = null;
		this.battery = false;
		this.state = null; // Assuming state is a String representation of DeviceState
	}
}
