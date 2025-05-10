package com.guardion.app.demo.controller.device;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.dto.device.GetDeviceInfoResponse;
import com.guardion.app.demo.dto.device.GetUsersAllDeviceResponse;
import com.guardion.app.demo.dto.device.RegisterDeviceRequest;
import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.service.device.DeviceService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/device")
public class DeviceController {

	private final DeviceService deviceService;

	@PostMapping("/{username}")
	public ResponseEntity<ApiResponse<Void>> registerDevice(@RequestBody @Valid RegisterDeviceRequest request, @PathVariable String username) {
		deviceService.registerDevice(request, username);
		return ResponseEntity.ok(ApiResponse.successWithNoData());
	}

	@GetMapping("/{username}")
	public ResponseEntity<ApiResponse<List<GetUsersAllDeviceResponse>>> getUsersAllDevice(@PathVariable String username) {
		List<GetUsersAllDeviceResponse> list = deviceService.getUsersAllDevice(username);
		return ResponseEntity.ok(ApiResponse.success(list));
	}

	@GetMapping("/{username}/{serialNumber}")
	public ResponseEntity<ApiResponse<GetDeviceInfoResponse>> getDeviceInfo(@PathVariable String username, @PathVariable String serialNumber) {
		GetDeviceInfoResponse response = deviceService.getDeviceInfo(username, serialNumber);
		return ResponseEntity.ok(ApiResponse.success(response));
	}
}
