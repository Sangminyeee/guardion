package com.guardion.app.demo.dto.deviceData;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetTemperatureHumidityResponse {
	private Float temperature;
	private Float Humidity;
	private Long temperatureDiff;
	private Long humidityDiff;
}
