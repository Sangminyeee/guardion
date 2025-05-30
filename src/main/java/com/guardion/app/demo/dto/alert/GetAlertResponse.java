package com.guardion.app.demo.dto.alert;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetAlertResponse {

	private String alertCode;
	private String alertType;
	private String alertMessage;
}
