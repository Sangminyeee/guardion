package com.guardion.app.demo.converter;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import com.guardion.app.demo.domain.Alert;
import com.guardion.app.demo.dto.alert.GetAlertResponse;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class AlertConverter {

	public List<GetAlertResponse> alertsToGetAllAlertResponse(List<Alert> alerts) {
		List<GetAlertResponse> list = new ArrayList<>();
		for (Alert alert : alerts) {
			list.add(new GetAlertResponse(alert.getAlertCode(), alert.getAlertType().toString(),
				alert.getMessage()));
		}
		return list;
	}
}
