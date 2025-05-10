package com.guardion.app.demo.converter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.dto.device.GetDeviceInfoResponse;
import com.guardion.app.demo.dto.device.GetUsersAllDeviceResponse;
import com.guardion.app.demo.dto.device.RegisterDeviceRequest;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DeviceConverter {

	public Device registerDeviceRequestToDevice(RegisterDeviceRequest request, User user) {
		return Device.builder()
			.user(user)
			.serialNumber(request.getSerialNumber())
			.deviceName(null)
			.temperatureSetting(null)
			.beepSetting(null)
			.lightSetting(null)
			.isConnected(null)
			.lastRecordedAt(LocalDateTime.now())
			.build();
	}

	public List<GetUsersAllDeviceResponse> devicesToGetUsersAllDeviceResponse(List<Device> devices) {
		List<GetUsersAllDeviceResponse> list = new ArrayList<>();
		for (Device device : devices) {
			list.add(new GetUsersAllDeviceResponse(device.getSerialNumber(), device.getDeviceName()));
		}
		return list;
	}

	public GetDeviceInfoResponse deviceToGetDeviceInfoResponse(Device device) {
		return new GetDeviceInfoResponse(device.getSerialNumber(), device.getDeviceName(),
			device.getTemperatureSetting(), device.getBeepSetting(), device.getLightSetting(),
			device.getIsConnected(), device.getLastRecordedAt().toString());
	}
}
