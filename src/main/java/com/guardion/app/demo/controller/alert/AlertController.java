package com.guardion.app.demo.controller.alert;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.dto.alert.GetAlertResponse;
import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.service.alert.AlertService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/alert")
@RequiredArgsConstructor
public class AlertController {

	private final AlertService alertService;

	@GetMapping("/all/{serialNumber}")
	public ResponseEntity<ApiResponse<List<GetAlertResponse>>> getAllAlert(@PathVariable String serialNumber) {
		List<GetAlertResponse> list = alertService.getAllAlert(serialNumber);
		return ResponseEntity.ok(ApiResponse.success(list));
	}

}
