package com.guardion.app.demo.controller.device;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
import com.guardion.app.demo.security.CustomUserDetails;
import com.guardion.app.demo.service.device.DeviceService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/device")
public class DeviceController {

	private final DeviceService deviceService;

	@PostMapping
	public ResponseEntity<ApiResponse<Void>> registerDevice(
		@RequestBody @Valid RegisterDeviceRequest request,
		@AuthenticationPrincipal CustomUserDetails customUserDetails
	) {
		Long userId = customUserDetails.getUserId();
		deviceService.registerDevice(request, userId);
		return ResponseEntity.ok(ApiResponse.successWithNoData());
	}

	@GetMapping
	public ResponseEntity<ApiResponse<List<GetUsersAllDeviceResponse>>> getUsersAllDevice(
		@AuthenticationPrincipal CustomUserDetails customUserDetails
	) {
		Long userId = customUserDetails.getUserId();
		List<GetUsersAllDeviceResponse> list = deviceService.getUsersAllDevice(userId);
		return ResponseEntity.ok(ApiResponse.success(list));
	}

	@GetMapping("{serialNumber}")
	public ResponseEntity<ApiResponse<GetDeviceInfoResponse>> getDeviceInfo(
		@PathVariable String serialNumber,
		@AuthenticationPrincipal CustomUserDetails customUserDetails
	) {
		Long userId = customUserDetails.getUserId();
		GetDeviceInfoResponse response = deviceService.getDeviceInfo(userId, serialNumber);
		return ResponseEntity.ok(ApiResponse.success(response));
	}
}
