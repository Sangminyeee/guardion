package com.guardion.app.demo.converter;

import org.springframework.stereotype.Component;

import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.alert.SseSendAlert;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class SseConverter {

	public SseSendAlert deviceDataToSseSendAlert(DeviceData deviceData) {
		return SseSendAlert.builder()
			.deviceState(deviceData.getState().toString())
			.deviceSerialNumber(deviceData.getDevice().getSerialNumber())
			.alertTime(deviceData.getCreatedAt())
			.build();
	}
}
