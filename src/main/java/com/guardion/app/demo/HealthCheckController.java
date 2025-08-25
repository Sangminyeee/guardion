package com.guardion.app.demo;

import java.time.LocalDateTime;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.tags.Tag;

@Tag(name = "헬스체크 API", description = "서버 상태 확인용")
@RestController
public class HealthCheckController {

	@GetMapping("/health")
	public String healthCheck() {
		return LocalDateTime.now().toString();
	}
}
