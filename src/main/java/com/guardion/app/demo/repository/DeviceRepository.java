package com.guardion.app.demo.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.guardion.app.demo.domain.Device;

@Repository
public interface DeviceRepository extends JpaRepository<Device, Long> {
	//List<Device> findBySomeField(String someField);
}
