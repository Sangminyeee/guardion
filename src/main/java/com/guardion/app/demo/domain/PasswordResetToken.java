package com.guardion.app.demo.domain;

import java.time.Instant;
import java.time.LocalDateTime;

import com.guardion.app.demo.domain.common.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Builder(toBuilder = true)
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "password_reset_token")
public class PasswordResetToken extends BaseEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name="user_id", nullable=false)
	private String userName;

	@Column(name="token_hash", nullable=false, columnDefinition = "VARBINARY(64)")
	private byte[] tokenHash;

	@Column(name="expires_at", nullable=false)
	private LocalDateTime expiresAt;

	@Column(name="used_at")
	private LocalDateTime usedAt;

	public void setUsedAt(LocalDateTime time) {
		this.usedAt = time;
	}
}
