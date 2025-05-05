package com.guardion.app.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.guardion.app.demo.domain.DeviceData;

@Repository
public interface DeviceDataRepository extends JpaRepository<DeviceData, Long> {
}
