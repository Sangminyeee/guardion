package com.guardion.app.demo.converter;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import com.guardion.app.demo.domain.Alert;
import com.guardion.app.demo.dto.alert.GetAlertResponse;
import com.guardion.app.demo.dto.alert.GetAlertResponseDetailed;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class AlertConverter {

	public List<GetAlertResponse> alertsToGetAllAlertResponse(List<Alert> alerts) {
		List<GetAlertResponse> list = new ArrayList<>();
		for (Alert alert : alerts) {
			list.add(new GetAlertResponse(alert.getDevice().getSerialNumber(), alert.getCreatedAt(), alert.getAlertType().toString()));
		}
		return list;
	}

	public GetAlertResponseDetailed alertToGetAlertResponseDetailed(Alert alert) {
		return new GetAlertResponseDetailed(
			alert.getDevice().getSerialNumber(),
			alert.getCreatedAt(),
			alert.getAlertType().toString(),
			alert.getMessage(),
			alert.getDeviceData().getInternalTemperature(),
			alert.getDeviceData().getInternalHumidity(),
			alert.getDeviceData().getTemperatureDiff(),
			alert.getDeviceData().getHumidityDiff(),
			alert.getDeviceData().getDoorStatus().toString(),
			alert.getDeviceData().getBatteryExists(),
			alert.getDeviceData().getBeepStatus(),
			alert.getDeviceData().getLightStatus()
		);
	}
}
