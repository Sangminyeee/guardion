package com.guardion.app.demo.domain;

import com.guardion.app.demo.domain.common.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
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
@Table(name = "`user`")
public class User extends BaseEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable = false, unique = true)
	private String username;

	@Column(nullable = false)
	private String password; // 여기에 bcrypt 해시를 저장

	@Column(name = "organization_name")
	private String organization;

	@Column(name = "institution_name")
	private String institution;

	@Column(nullable = false, columnDefinition = "VARCHAR(255) DEFAULT 'USER'")
	private String role;

	// @Column(name = "last_login_at")
	// private LocalDateTime lastLoginAt; :)
}
