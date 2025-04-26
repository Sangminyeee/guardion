package com.guardion.app.demo.domain;

import java.time.LocalDateTime;

import com.guardion.app.demo.domain.common.BaseEntity;
import com.guardion.app.demo.eunms.UserRole;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder(toBuilder = true)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class User extends BaseEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable = false, unique = true)
	private String username;

	@Column(name = "password_hash", nullable = false)
	private String passwordHash;

	@Column(name = "salt", nullable = false)
	private String salt;

	@Column(name = "organization_name")
	private String organization;

	@Column(name = "institution_name")
	private String institution;

	@Enumerated(EnumType.STRING)
	@Column(nullable = false)
	private UserRole role;

	// @Column(name = "last_login_at")
	// private LocalDateTime lastLoginAt;
}
