package com.guardion.app.demo.service.device;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.converter.DeviceConverter;
import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.dto.device.GetDeviceInfoResponse;
import com.guardion.app.demo.dto.device.GetUsersAllDeviceResponse;
import com.guardion.app.demo.dto.device.RegisterDeviceRequest;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.DeviceRepository;
import com.guardion.app.demo.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeviceService {

	private final DeviceRepository deviceRepository;
	private final UserRepository userRepository;
	private final DeviceConverter deviceConverter;

	@Transactional
	public void registerDevice(RegisterDeviceRequest request, String username) {
		User user =  userRepository.findByUsername(username)
			.orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

		if (deviceRepository.existsByUserIdAndSerialNumber(user.getId(), request.getSerialNumber())) {
			throw new BusinessException(ErrorCode.DEVICE_ALREADY_REGISTERED);
		}

		Device device = deviceConverter.registerDeviceRequestToDevice(request, user);

		deviceRepository.save(device);
	}

	@Transactional(readOnly = true)
	public List<GetUsersAllDeviceResponse> getUsersAllDevice(String username) {
		List<Device> devices = deviceRepository.findAllByUser_Username(username);
		if (devices.isEmpty()) {
			throw new BusinessException(ErrorCode.DEVICE_NOT_FOUND);
		}

		return deviceConverter.devicesToGetUsersAllDeviceResponse(devices);
	}

	@Transactional(readOnly = true)
	public GetDeviceInfoResponse getDeviceInfo(String username, String serialNumber) {
		Device device = deviceRepository.findByUser_UsernameAndSerialNumber(username, serialNumber)
			.orElseThrow(() -> new BusinessException(ErrorCode.DEVICE_NOT_FOUND));

		return deviceConverter.deviceToGetDeviceInfoResponse(device);
	}

}
