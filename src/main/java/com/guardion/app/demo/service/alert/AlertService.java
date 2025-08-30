package com.guardion.app.demo.service.alert;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.converter.AlertConverter;
import com.guardion.app.demo.domain.Alert;
import com.guardion.app.demo.domain.Device;
import com.guardion.app.demo.dto.alert.GetAlertResponse;
import com.guardion.app.demo.dto.alert.GetAlertResponseDetailed;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.AlertRepository;
import com.guardion.app.demo.repository.DeviceRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AlertService {

	private final AlertRepository alertRepository;
	private final DeviceRepository deviceRepository;
	private final AlertConverter alertConverter;

	@Transactional(readOnly = true)
	public List<GetAlertResponse> getAllAlert(Long userId) {
		List<Alert> alerts = alertRepository.findByUserIdOrderByCreatedAtDesc(userId);

		if (alerts.isEmpty()) {
			throw new BusinessException(ErrorCode.NO_ALERTS_FOR_DEVICE);
		}
		return alertConverter.alertsToGetAllAlertResponse(alerts);
	}

	@Transactional(readOnly = true)
	public GetAlertResponseDetailed getAlertDetail(Long alertId) {
		Alert alert = alertRepository.findById(alertId)
			.orElseThrow(() -> new BusinessExcepti\on(ErrorCode.NO_ALERTS_FOR_DEVICE));

		return alertConverter.alertToGetAlertResponseDetailed(alert);
	}
}
