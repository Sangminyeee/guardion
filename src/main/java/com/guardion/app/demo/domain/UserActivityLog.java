package com.guardion.app.demo.domain;

import com.guardion.app.demo.domain.common.BaseEntity;
import com.guardion.app.demo.eunms.ActivityType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
public class UserActivityLog extends BaseEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "user_id", nullable = false)
	private Users user;

	@Column(name = "activity_type")
	private ActivityType activityType; // login, logout, update_device, etc.

	//고민중
	// @Column(name = "activity_target")
	// private String activityTarget; // 활동 대상 (예: 경로, 리소스 ID 등)

	//고민중
	// @Column(name = "activity_detail")
	// private String activityDetail; // 활동 상세 정보 (변경 전/후 값 등)

	//고도화
	// @Column(name = "ip_address")
	// private String ipAddress; // 사용자 IP 주소 (DB에서는 inet 타입, 자바에서는 String)

	//고도화
	// @Column(name = "user_agent")
	// private String userAgent; // 브라우저 또는 디바이스 정보
}
