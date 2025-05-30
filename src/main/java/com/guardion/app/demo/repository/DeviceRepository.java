package com.guardion.app.demo.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.guardion.app.demo.domain.Device;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
	//List<Device> findBySomeField(String someField);
	List<Device> findAllByUserId(Long userId);
	List<Device> findAllByUser_Username(String username);
	Optional<Device> findByUser_UsernameAndSerialNumber(String serialNumber, String username);
	boolean existsBySerialNumber(String serialNumber);
	Optional<Device> findBySerialNumber(String serialNumber);
	boolean existsByUserIdAndSerialNumber(Long userId, String serialNumber);
}
