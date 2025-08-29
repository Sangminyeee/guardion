package com.guardion.app.demo.security.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class NewPasswordPostRequest {

	@NotBlank(message = "Username is required.")
	private String username;

	@NotBlank(message = "New password is required.")
	private String newPassword;
}
