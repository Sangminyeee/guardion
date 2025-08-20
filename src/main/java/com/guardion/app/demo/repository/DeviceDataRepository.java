package com.guardion.app.demo.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;

@Repository
public interface DeviceDataRepository extends JpaRepository<DeviceData, Long> {

	Optional<DeviceData> findTopByDevice_SerialNumberOrderByCreatedAtDesc(String deviceSerialNumber);
	Optional<DeviceData> findTopByDeviceIdOrderByCreatedAtDesc(Long deviceId);
}
