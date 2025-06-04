package com.guardion.app.demo.dto.deviceData;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetTemperatureHumidityResponse {
	private double temperature;
	private double Humidity;
}
