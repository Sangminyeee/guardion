package com.guardion.app.demo.dto.alert;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@AllArgsConstructor
@Builder
public class SseSendAlert {

	private String deviceState;
}
