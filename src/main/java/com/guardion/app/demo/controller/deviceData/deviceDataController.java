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

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/device-data")
@RequiredArgsConstructor
public class deviceDataController {

	private final DeviceDataService deviceDataService;
	private final DeviceDataRepository deviceDataRepository;

	//홈화면 데이터 간략히 조회
	@GetMapping("/temperature-humidity/{serialNumber}")
	public ResponseEntity<ApiResponse<GetTemperatureHumidityResponse>> getTemperatureHumidity(@PathVariable String serialNumber) {
		GetTemperatureHumidityResponse response = deviceDataService.getTemperatureHumidity(serialNumber);
		return ResponseEntity.ok(ApiResponse.success(response));
	}

	//데이터 상세 조회
	@GetMapping("/{serialNumber}")
	public ResponseEntity<ApiResponse<GetDeviceDataResponse>> getDeviceData(@PathVariable String serialNumber) {
		GetDeviceDataResponse response = deviceDataService.getDeviceData(serialNumber);
		return ResponseEntity.ok(ApiResponse.success(response));
	}
}
