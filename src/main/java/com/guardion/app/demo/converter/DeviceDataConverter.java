package com.guardion.app.demo.converter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.deviceData.GetDeviceDataResponse;
import com.guardion.app.demo.dto.mqtt.MqttTestRequest;
import com.guardion.app.demo.dto.mqtt.MqttTestRequestDetailed;
import com.guardion.app.demo.dto.deviceData.GetTemperatureHumidityResponse;
import com.guardion.app.demo.dto.mqtt.SensorData;
import com.guardion.app.demo.eunms.DeviceState;
import com.guardion.app.demo.eunms.DoorStatus;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.DeviceRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class DeviceDataConverter {

	@Autowired
	DeviceRepository deviceRepository;

	public DeviceData mqttTestRequestToDeviceData(MqttTestRequest dto) {
		try {
			Device device = deviceRepository.findById(dto.getDeviceId())
				.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

			return DeviceData.builder()
					.device(device)
					.internalHumidity(dto.getMessage())
					.build();
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
	}

	public DeviceData mqttTestRequestDetailedToDeviceData(MqttTestRequestDetailed dto) {
		try {
			Device device = deviceRepository.findById(dto.getDeviceId())
				.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

			//남은 데이터 device 에 저장
			return DeviceData.builder()
					.device(device)
					.internalTemperature(dto.getTemperature())
					.internalHumidity(dto.getHumidity())
					.doorStatus(DoorStatus.valueOf(dto.getDoor().toUpperCase()))
					.batteryExists(dto.isBattery())
					.beepStatus(dto.isBeep())
					.lightStatus(dto.isLight())
					.build();
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
	}

	public DeviceData sensorDataToDeviceData(SensorData dto) {
		try {
			Device device = deviceRepository.findBySerialNumber(dto.getContainer())
				.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

			return DeviceData.builder()
					.device(device)
					.internalTemperature(dto.getTemp())
					.internalHumidity(dto.getHum())
					.temperatureDiff(dto.getTempDiff())
					.humidityDiff(dto.getHumDiff())
					.doorStatus(DoorStatus.valueOf(dto.getDoor().toUpperCase()))
					.batteryExists(dto.isBattery())
					.state(DeviceState.valueOf(dto.getState().toUpperCase()))
					.build();
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
	}

	public GetTemperatureHumidityResponse deviceDataToGetTemperatureHumidityResponse(DeviceData deviceData) {
		return new GetTemperatureHumidityResponse(deviceData.getInternalTemperature(), deviceData.getInternalHumidity(),
			deviceData.getTemperatureDiff(), deviceData.getHumidityDiff());
	}

	public GetDeviceDataResponse deviceDataToGetDeviceDataResponse(DeviceData deviceData) {
		return new GetDeviceDataResponse(
			deviceData.getInternalTemperature(),
			deviceData.getInternalHumidity(),
			deviceData.getTemperatureDiff(),
			deviceData.getHumidityDiff(),
			deviceData.getDoorStatus().toString()
		);
	}
}
