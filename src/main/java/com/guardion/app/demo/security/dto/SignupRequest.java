package com.guardion.app.demo.security.dto;

import com.guardion.app.demo.domain.User;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SignupRequest {
	private String username;
	private String password;
	private String institution;

	public User toEntity(String encodedPassword) {
		return User.builder()
				.username(username)
				.password(encodedPassword)
				.institution(institution)
				.build();
	}
}
