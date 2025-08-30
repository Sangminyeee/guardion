package com.guardion.app.demo.security.dto;

import java.time.LocalDateTime;

import com.guardion.app.demo.domain.PendingUser;
import com.guardion.app.demo.domain.User;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SignupCodeRequest {

	@NotBlank(message = "Username is required")
	private String username;

	@NotBlank(message = "Password is required")
	private String password;

	private String institution;

	@NotBlank(message = "Email is required")
	private String email;

	@NotBlank(message = "Birth date is required.")
	private String birthDate; // "yyyyMMdd"

	public User toEntity(String encodedPassword) {
		return User.builder()
				.username(username)
				.password(encodedPassword)
				.institution(institution)
				.email(email)
				.build();
	}

	public PendingUser toPendingUser(String encodedPassword, String encodedCode, LocalDateTime expiresAt) {
		return PendingUser.builder()
				.username(username)
				.email(email)
				.birthDate(birthDate) // Not used in signup, set to empty string
				.password(encodedPassword)
				.code(encodedCode)
				.expiresAt(expiresAt)
				.attempts(0)
				.build();
	}
}
