package com.guardion.app.demo.dto.device;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateDeviceInfoRequest {

	@NotBlank(message = "Serial Number is required")
	private String serialNumber;
}
