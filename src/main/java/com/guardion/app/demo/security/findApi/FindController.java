package com.guardion.app.demo.security.findApi;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.security.dto.PasswordResetRequest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;

@Tag(name = "아이디/비밀번호 찾기 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/auth")
public class FindController {

	private final FindService findService;

	@Operation(summary = "비밀번호 재설정 요청 api", description = "인증코드 이메일을 반환받음.")
	@PostMapping("/password/reset-request")
	public ResponseEntity<ApiResponse<String>> sendMailToUser(@RequestBody @Valid PasswordResetRequest request) {
		String content = findService.sendMailToUser(request);
		return ResponseEntity.ok(ApiResponse.success(content));
	}

	// @GetMapping
}
