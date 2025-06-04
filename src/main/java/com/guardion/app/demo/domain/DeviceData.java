package com.guardion.app.demo.domain;

import java.time.LocalDateTime;

import com.guardion.app.demo.domain.common.BaseEntity;
import com.guardion.app.demo.eunms.DeviceState;
import com.guardion.app.demo.eunms.DoorStatus;

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
public class DeviceData extends BaseEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne
	@JoinColumn(name = "device_id", nullable = false)
	private Device device;

	@Column(name = "internal_temperature")
	private double internalTemperature;

	@Column(name = "internal_humidity")
	private double internalHumidity;

	@Column(name = "temperature_diff")
	private double temperatureDiff; // 이전 데이터 기준 차이

	@Column(name = "humifity_diff")
	private double humidityDiff; // 이전 데이터 기준 차이

	@Enumerated(EnumType.STRING)
	@Column(name = "door_status")
	private DoorStatus doorStatus;

	@Column(name = "battery_exists")
	private Boolean batteryExists; // 1:yes, 0:no

	@Column(name = "beep_status")
	private Boolean beepStatus; // 1:on, 0:off

	@Column(name = "light_status")
	private Boolean lightStatus; // 1:on, 0:off

	@Enumerated(EnumType.STRING)
	@Column(name = "state")
	private DeviceState state;

	// @OneToOne(cascade = CascadeType.ALL)
	// @JoinColumn(name = "device_gps_id")
	// private DeviceGpsLog deviceGps;
}
