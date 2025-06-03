package com.guardion.app.demo.dto.deviceData;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetDeviceDataResponse {

	private Float temperature;
	private Float Humidity;
	private Float temperatureDiff;
	private Float humidityDiff;
	private boolean door;
}
