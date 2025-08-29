package com.guardion.app.demo.security.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class FindUsernameRequest {

	@NotBlank(message = "Birth date is required.")
	private String birthDate; // yyyy-MM-dd

	@NotBlank(message = "Email is required.")
	private String email;
}
