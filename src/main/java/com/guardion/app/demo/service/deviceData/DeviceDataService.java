package com.guardion.app.demo.service.deviceData;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.converter.DeviceDataConverter;
import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.dto.deviceData.GetDeviceDataResponse;
import com.guardion.app.demo.dto.deviceData.GetTemperatureHumidityResponse;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.DeviceDataRepository;
import com.guardion.app.demo.repository.DeviceRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeviceDataService {

	private final DeviceDataRepository deviceDataRepository;
	private final DeviceRepository deviceRepository;
	private final DeviceDataConverter deviceDataConverter;

	//홈화면 데이터 간략히 조회
	@Transactional(readOnly = true)
	public GetTemperatureHumidityResponse getTemperatureHumidity(String serialNumber) {
		Device device = deviceRepository.findBySerialNumber(serialNumber)
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));
		DeviceData deviceData = deviceDataRepository.findTopByDeviceIdOrderByCreatedAtDesc(device.getId())
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_DATA_NOT_FOUND));

		return deviceDataConverter.deviceDataToGetTemperatureHumidityResponse(deviceData);
	}

	//데이터 상세 조회
	@Transactional(readOnly = true)
	public GetDeviceDataResponse getDeviceData(String serialNumber) {
		Device device = deviceRepository.findBySerialNumber(serialNumber)
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));
		DeviceData deviceData = deviceDataRepository.findTopByDeviceIdOrderByCreatedAtDesc(device.getId())
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_DATA_NOT_FOUND));

		return deviceDataConverter.deviceDataToGetDeviceDataResponse(deviceData);
	}
}
