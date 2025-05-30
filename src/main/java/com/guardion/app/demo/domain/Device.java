package com.guardion.app.demo.domain;

import java.time.LocalDateTime;

import com.guardion.app.demo.domain.common.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "device", uniqueConstraints = {
	@UniqueConstraint(columnNames = {"user_id", "serial_number"})
})
public class Device extends BaseEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(optional = false)
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	@Column(name = "serial_number")
	private String serialNumber;

	@Column(name = "device_name")
	private String deviceName;

	@Column(name = "temperature_setting")
	private Integer temperatureSetting;

	@Column(name = "beep_setting")
	private Integer beepSetting;

	@Column(name = "light_setting")
	private Integer lightSetting;

	private boolean beep; // 1:on, 0:off

	private boolean light; // 1:on, 0:off

	@Column(name = "is_connected")
	private Boolean isConnected;

	@Column(name = "data_last_recorded_at")
	private LocalDateTime lastRecordedAt;
}
