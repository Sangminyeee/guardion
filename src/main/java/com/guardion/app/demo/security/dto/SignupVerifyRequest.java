package com.guardion.app.demo.security.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SignupVerifyRequest {

	@NotBlank(message = "Email is required.")
	private String email;

	@NotBlank(message = "Verification code is required.")
	private String code;
}
