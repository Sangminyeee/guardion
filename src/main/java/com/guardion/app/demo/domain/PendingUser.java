package com.guardion.app.demo.domain;

import java.time.LocalDateTime;

import com.guardion.app.demo.domain.common.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "pending_user",
	uniqueConstraints = {
		@UniqueConstraint(name = "uk_pending_email", columnNames = "email"),
		@UniqueConstraint(name = "uk_pending_username", columnNames = "username")
	})
public class PendingUser extends BaseEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable=false, length=254, unique = true)
	private String email;

	@Column(nullable=false, length=50, unique = true)
	private String username;

	@Column(nullable=false, length=255)
	private String password; //hashed password

	@Column(nullable=false, length=128)
	private String code; //hashed code

	@Column(nullable=false)
	private LocalDateTime expiresAt;

	@Column(nullable=false)
	private Integer attempts = 0;

	// private LocalDateTime lastSentAt;

	public void setAttempts(Integer attempts) {
		this.attempts = attempts;
	}
}
