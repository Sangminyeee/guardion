package com.guardion.app.demo.dto.device;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class RegisterDeviceRequest {

	@NotBlank(message = "Serial Number is required")
	private String serialNumber;
}
