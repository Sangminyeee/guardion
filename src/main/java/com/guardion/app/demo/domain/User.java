package com.guardion.app.demo.domain;

import com.guardion.app.demo.domain.common.BaseEntity;
import com.guardion.app.demo.eunms.UserRole;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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

	@Column(nullable = false)
	private String username;

	@Column(nullable = false)
	private String password; // 여기에 bcrypt 해시를 저장

	@Column(nullable = false, unique = true)
	private String email;

	@Column(name = "birth_date", nullable = false)
	private String birthDate; // "yyyyMMdd"

	@Column(name = "token_version")
	private int tokenVersion;

	@Column(name = "find_id_hash_code")
	private String findUsernameHashCode;

	@Column(name = "organization_name")
	private String organization;

	@Column(name = "institution_name")
	private String institution;

	@Builder.Default
	@Enumerated(EnumType.STRING)
	@Column(nullable = false)
	private UserRole role = UserRole.VIEWER;

	public void setPassword(String newPassword) {
		this.password = newPassword;
	}

	public void setTokenVersion(int i) {
		this.tokenVersion = i;
	}

	public void setFindUsernameHashCode(String code) {
		this.findUsernameHashCode = code;
	}
}
