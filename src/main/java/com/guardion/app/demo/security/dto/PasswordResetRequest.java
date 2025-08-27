package com.guardion.app.demo.security.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class PasswordResetRequest {

	@NotBlank(message = "Username is required.")
	private String username;

	@NotBlank(message = "Email is required.")
	private String email;

}
