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

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Tag(name = "함체 API", description = "함체 등록 및 조회 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/device")
public class DeviceController {

	private final DeviceService deviceService;

	//함체 등록
	@Operation(summary = "함체 등록 API", description = "함체 등록 페이지용")
	@PostMapping
	public ResponseEntity<ApiResponse<Void>> registerDevice(
		@RequestBody @Valid RegisterDeviceRequest request,
		@AuthenticationPrincipal CustomUserDetails customUserDetails
	) {
		Long userId = customUserDetails.getUserId();
		deviceService.registerDevice(request, userId);
		return ResponseEntity.ok(ApiResponse.successWithNoData());
	}

	//사용자의 모든 함체 조회
	@Operation(summary = "특정 사용자의 모든 함체 조회 API", description = "홈화면의 온도, 습도 위에 표시용")
	@GetMapping
	public ResponseEntity<ApiResponse<List<GetUsersAllDeviceResponse>>> getUsersAllDevice(
		@AuthenticationPrincipal CustomUserDetails customUserDetails
	) {
		Long userId = customUserDetails.getUserId();
		List<GetUsersAllDeviceResponse> list = deviceService.getUsersAllDevice(userId);
		return ResponseEntity.ok(ApiResponse.success(list));
	}

	//개별 함체 정보 조회
	@Operation(summary = "함체 정보 상세 조회 API", description = "지금은 필요 없는 것 같습니다.")
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
