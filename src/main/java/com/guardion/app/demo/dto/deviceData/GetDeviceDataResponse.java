package com.guardion.app.demo.dto.deviceData;

import com.guardion.app.demo.domain.DeviceData;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetDeviceDataResponse {

	private double temperature;
	private double Humidity;
	private double temperatureDiff;
	private double humidityDiff;
	private String door;
}
