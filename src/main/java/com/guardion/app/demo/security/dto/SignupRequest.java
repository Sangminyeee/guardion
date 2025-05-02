package com.guardion.app.demo.security.dto;

import com.guardion.app.demo.domain.Users;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SignupRequest {
	private String username;
	private String password;
	private String organization;
	private String institution;
	private String role;

	public Users toEntity(String encodedPassword) {
		return Users.builder()
				.username(username)
				.password(encodedPassword)
				.organization(organization)
				.institution(institution)
				.role(role)
				.build();
	}
}
