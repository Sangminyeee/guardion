package com.guardion.app.demo.domain;

import com.guardion.app.demo.domain.common.BaseEntity;
import com.guardion.app.demo.eunms.AlertSeverity;
import com.guardion.app.demo.eunms.AlertType;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
public class Alert extends BaseEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(optional = false)
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	@ManyToOne(optional = false)
	@JoinColumn(name = "device_id", nullable = false)
	private Device device;

	@Column(name = "alert_code")
	private String alertCode;

	@Column(name = "alert_type")
	private String alertType;

	@OneToOne(cascade = CascadeType.PERSIST)
	@JoinColumn(name = "device_data_id")
	private DeviceData deviceData;

	private String message;

	@Enumerated(EnumType.STRING)
	@Column(name = "alert_severity")
	private AlertSeverity alertSeverity;

	private Boolean isRead = false; // 1:yes, 0:no

	private Boolean isResolved = false; // 1:yes, 0:no

}
