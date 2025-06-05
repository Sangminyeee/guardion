package com.guardion.app.demo.controller.deviceData;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.dto.deviceData.GetDeviceDataResponse;
import com.guardion.app.demo.dto.deviceData.GetTemperatureHumidityResponse;
import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.repository.DeviceDataRepository;
import com.guardion.app.demo.service.deviceData.DeviceDataService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@Tag(name = "함체 데이터 API", description = "함체 데이터 조회 API")
@RestController
@RequestMapping("/device-data")
@RequiredArgsConstructor
public class deviceDataController {

	private final DeviceDataService deviceDataService;
	private final DeviceDataRepository deviceDataRepository;

	//홈화면 데이터 간략히 조회
	@Operation(summary = "함체 데이터 조회 API", description = "홈화면에 간략히 표시 용")
	@GetMapping("/temperature-humidity/{serialNumber}")
	public ResponseEntity<ApiResponse<GetTemperatureHumidityResponse>> getTemperatureHumidity(@PathVariable String serialNumber) {
		GetTemperatureHumidityResponse response = deviceDataService.getTemperatureHumidity(serialNumber);
		return ResponseEntity.ok(ApiResponse.success(response));
	}

	//데이터 상세 조회
	@Operation(summary = "함체 데이터 상세 정보 조회 API", description = "홈화면의 함체 온도 습도 부분 클릭시")
	@GetMapping("/{serialNumber}")
	public ResponseEntity<ApiResponse<GetDeviceDataResponse>> getDeviceData(@PathVariable String serialNumber) {
		GetDeviceDataResponse response = deviceDataService.getDeviceData(serialNumber);
		return ResponseEntity.ok(ApiResponse.success(response));
	}
}
