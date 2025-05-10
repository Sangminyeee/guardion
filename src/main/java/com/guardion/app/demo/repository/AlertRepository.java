package com.guardion.app.demo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.guardion.app.demo.domain.Alert;

@Repository
public interface AlertRepository extends JpaRepository<Alert, Long> {
	// Custom query methods can be defined here if needed
	// For example:
	// List<Alert> findByAlertType(String alertType);
	List<Alert> findByDeviceIdOrderByCreatedAtDesc(Long deviceId);
}
