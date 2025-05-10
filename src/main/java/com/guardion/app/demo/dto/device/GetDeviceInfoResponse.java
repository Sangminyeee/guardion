package com.guardion.app.demo.dto.device;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetDeviceInfoResponse {

	private String serialNumber;
	private String deviceName;
	private Integer temperatureSetting;
	private Integer beepSetting;
	private Integer lightSetting;
	private Boolean isConnected;
	private String lastRecordedAt;
}
