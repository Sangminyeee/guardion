package com.guardion.app.demo.controller.alert;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.dto.alert.GetAlertResponse;
import com.guardion.app.demo.dto.alert.GetAlertResponseDetailed;
import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.security.CustomUserDetails;
import com.guardion.app.demo.service.alert.AlertService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/alert")
@RequiredArgsConstructor
public class AlertController {

	private final AlertService alertService;

	//홈화면 알림 목록 조회(모든 함체에 대한 알림)
	@GetMapping("/all")
	public ResponseEntity<ApiResponse<List<GetAlertResponse>>> getAllAlert(
		@AuthenticationPrincipal CustomUserDetails customUserDetails) {
		Long userId = customUserDetails.getUserId();
		List<GetAlertResponse> list = alertService.getAllAlert(userId);
		return ResponseEntity.ok(ApiResponse.success(list));
	}

	//개별 알림 상세 조회
	@GetMapping("/{alertId}")
	public ResponseEntity<ApiResponse<GetAlertResponseDetailed>> getAlertDetail(@PathVariable Long alertId) {
		GetAlertResponseDetailed response = alertService.getAlertDetail(alertId);
		return ResponseEntity.ok(ApiResponse.success(response));
	}
}
