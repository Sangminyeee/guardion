package com.guardion.app.demo.dto.alert;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class GetAlertResponse {

	private String deviceSerialNumber;
	private LocalDateTime alertTime;
	private String message;
}
