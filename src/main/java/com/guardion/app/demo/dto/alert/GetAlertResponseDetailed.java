package com.guardion.app.demo.dto.alert;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetAlertResponseDetailed {
	private String deviceSerialNumber;
	private LocalDateTime alertTime;
	private String alertType;
	private String alertMessage;

	private Float internalTemperature;
	private Float internalHumidity;
	private Float temperatureDiff;
	private Float humidityDiff;
	private Boolean doorStatus; // 1:open, 0:closed
	private Boolean batteryExists; // 1:yes, 0:no
	private Boolean beepStatus; // 1:on, 0:off
	private Boolean lightStatus; // 1:on, 0:off
}
