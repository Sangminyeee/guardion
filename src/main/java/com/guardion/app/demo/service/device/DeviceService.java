package com.guardion.app.demo.service.device;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.converter.DeviceConverter;
import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.DeviceData;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.dto.device.UpdateDeviceInfoRequest;
import com.guardion.app.demo.dto.device.GetDeviceInfoResponse;
import com.guardion.app.demo.dto.device.GetUsersAllDeviceResponse;
import com.guardion.app.demo.dto.device.RegisterDeviceRequest;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.DeviceDataRepository;
import com.guardion.app.demo.repository.DeviceRepository;
import com.guardion.app.demo.repository.UserRepository;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeviceService {

	private final DeviceRepository deviceRepository;
	private final UserRepository userRepository;
	private final DeviceConverter deviceConverter;
	private final DeviceDataRepository deviceDataRepository;

	@Transactional
	public void registerDevice(RegisterDeviceRequest request, Long userId) {
		User user = userRepository.findById(userId)
			.orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

		if (deviceRepository.existsByUserIdAndSerialNumber(userId, request.getSerialNumber())) {
			throw new BusinessException(ErrorCode.DEVICE_ALREADY_REGISTERED);
		}

		Device device = deviceConverter.registerDeviceRequestToDevice(request, user);

		deviceRepository.save(device);
	}

	@Transactional(readOnly = true)
	public List<GetUsersAllDeviceResponse> getUsersAllDevice(Long userId) {
		List<Device> devices = deviceRepository.findAllByUserId(userId);
		if (devices.isEmpty()) {
			throw new BusinessException(ErrorCode.DEVICE_NOT_FOUND);
		}

		return deviceConverter.devicesToGetUsersAllDeviceResponse(devices);
	}

	@Transactional(readOnly = true)
	public GetDeviceInfoResponse getDeviceInfo(Long userId, String serialNumber) {
		Device device = deviceRepository.findByUserIdAndSerialNumber(userId, serialNumber)
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

		return deviceConverter.deviceToGetDeviceInfoResponse(device);
	}

	@Transactional
	public void deleteDevice(Long userId, String serialNumber) {
		Device device = deviceRepository.findByUserIdAndSerialNumber(userId, serialNumber)
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

		deviceRepository.delete(device);
	}

	@Transactional
	public void updateDeviceInfo(Long userId, String serialNumber, @Valid UpdateDeviceInfoRequest request) {
		Device device = deviceRepository.findByUserIdAndSerialNumber(userId, serialNumber)
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

		if (request.getSerialNumber() != null) device.setSerialNumber(request.getSerialNumber());
	}

	@Transactional(readOnly = true)
	public String getDeviceStatus(Long userId, String serialNumber) {
		Device device = deviceRepository.findByUserIdAndSerialNumber(userId, serialNumber)
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

		DeviceData deviceData = deviceDataRepository.findTopByDeviceIdOrderByCreatedAtDesc(device.getId())
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_DATA_NOT_FOUND));

		return deviceData.getState().toString();
	}
}
