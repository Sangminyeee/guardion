package com.guardion.app.demo.converter;

import org.springframework.stereotype.Component;

import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.MqttTestDto;
import com.guardion.app.demo.repository.DeviceDataRepository;
import com.guardion.app.demo.repository.DeviceRepository;

import lombok.AllArgsConstructor;

@Component
@AllArgsConstructor
public class DeviceDataConverter {

	DeviceRepository deviceRepository;

	public DeviceData mqttTestDtoToDeviceData(MqttTestDto dto) {
		Device device = deviceRepository.findById(dto.getDeviceId())
				.orElseThrow(() -> new RuntimeException("Device not found"));

		return DeviceData.builder()
				.device(device)
				.internalHumidity(dto.getMessage())
				.build();
	}
}
