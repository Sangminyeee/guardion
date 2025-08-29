package com.guardion.app.demo.security.enterApi;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.repository.UserRepository;
import com.guardion.app.demo.security.JwtProvider;
import com.guardion.app.demo.security.dto.LoginRequest;
import com.guardion.app.demo.security.dto.SignupCodeRequest;
import com.guardion.app.demo.security.dto.SignupVerifyRequest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;

@Tag(name = "회원가입 및 로그인 API")
@RestController
@AllArgsConstructor
public class EnterController {

	private final UserRepository userRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtProvider jwtProvider;
	private final EnterService enterService;

	@Operation(summary = "회원가입 API (1 of 2 이메일 발송 요청) ", description = " 회원가입 시 이메일 인증코드 발송 요청 (10분 이내, 5회 미만 입력)")
	@PostMapping("/signup/code")
	public ResponseEntity<ApiResponse<String>> sendCode(@RequestBody @Valid SignupCodeRequest request) {
		String content = enterService.sendCode(request);
		return ResponseEntity.ok(ApiResponse.success(content));
	}

	@Operation(summary = "회원가입 API (2 of 2 인증코드 검증) ", description = "수신한 이메일 인증코드 검증 (사용자에게는 코드 입력 필드만 제공, email은 프론트에서 넘겨줄 수 있나요??)")
	@PostMapping("/signup/verify")
	public ResponseEntity<ApiResponse<String>> verifyCode(@RequestBody @Valid SignupVerifyRequest request) {
		String content = enterService.verifyCode(request);
		return ResponseEntity.ok(ApiResponse.success(content));
	}

	@Operation(summary = "로그인 API", description = "로그인 시")
	@PostMapping("/login")
	public ResponseEntity<ApiResponse<Void>> login(@RequestBody @Valid LoginRequest request) {
		String token = enterService.login(request);
		return ResponseEntity.ok()
			.header("Authorization", "Bearer " + token)
			.body(ApiResponse.successWithNoData());
	}
}
