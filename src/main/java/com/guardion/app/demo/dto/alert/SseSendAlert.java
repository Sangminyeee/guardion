package com.guardion.app.demo.dto.alert;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@AllArgsConstructor
@Builder
public class SseSendAlert {

	private String deviceSerialNumber;
	private String deviceState;
	private LocalDateTime alertTime;
}
