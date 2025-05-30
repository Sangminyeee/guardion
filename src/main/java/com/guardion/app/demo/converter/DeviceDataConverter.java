package com.guardion.app.demo.converter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.mqtt.MqttTestRequest;
import com.guardion.app.demo.dto.mqtt.MqttTestRequestDetailed;
import com.guardion.app.demo.dto.deviceData.GetTemperatureHumidityResponse;
import com.guardion.app.demo.repository.DeviceRepository;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DeviceDataConverter {

	@Autowired
	DeviceRepository deviceRepository;

	public DeviceData mqttTestRequestToDeviceData(MqttTestRequest dto) {
		Device device = deviceRepository.findById(dto.getDeviceId())
				.orElseThrow(() -> new RuntimeException("Device not found"));

		return DeviceData.builder()
				.device(device)
				.internalHumidity(dto.getMessage())
				.build();
	}

	public DeviceData mqttTestRequestDetailedToDeviceData(MqttTestRequestDetailed dto) {
		Device device = deviceRepository.findById(dto.getDeviceId())
				.orElseThrow(() -> new RuntimeException("Device not found"));

		//남은 데이터 device 에 저장(미완)
		return DeviceData.builder()
				.device(device)
				.internalTemperature(dto.getTemperature())
				.internalHumidity(dto.getHumidity())
				.doorStatus(dto.isDoor())
				.batteryExists(dto.isBattery())
				.beepStatus(dto.isBeep())
				.lightStatus(dto.isLight())
				.build();
	}

	public GetTemperatureHumidityResponse deviceDataToGetTemperatureHumidityResponse(DeviceData deviceData) {
		//이부분
		return new GetTemperatureHumidityResponse(deviceData.getInternalTemperature(), deviceData.getInternalHumidity(), 0L, 0L);
	}
}
