package com.guardion.app.demo.security.findApi;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.security.dto.FindUsernameRequest;
import com.guardion.app.demo.security.dto.NewPasswordPostRequest;
import com.guardion.app.demo.security.dto.PasswordResetRequest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Tag(name = "아이디/비밀번호 찾기 API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/auth")
public class FindController {

	private final FindService findService;

	@Operation(summary = "username(id) 찾기 api", description = "인증코드 이메일을 반환받음. (10분 이내) *요청 시 birthDate 는 20001010 형식으로 입력)")
	@PostMapping("/username/find-request")
	public ResponseEntity<ApiResponse<String>> sendMailToFindUsername(@RequestBody @Valid FindUsernameRequest request) {
		String content = findService.sendMailToFindUsername(request);
		return ResponseEntity.ok(ApiResponse.success(content));
	}

	@Operation(summary = "username(id) 찾기 인증코드 검증 api", description = "인증코드의 유효성을 체크 후 username 반환")
	@GetMapping("/username/find-verify")
	public ResponseEntity<ApiResponse<String>> verifyFindUsernameCode(@RequestParam String code, @RequestParam String email) {
		String content = findService.verifyFindUsernameCode(code, email);
		return ResponseEntity.ok(ApiResponse.success(content));
	}

	@Operation(summary = "비밀번호 재설정 요청 api", description = "인증코드 이메일을 반환받음. (10분 이내)")
	@PostMapping("/password/reset-request")
	public ResponseEntity<ApiResponse<String>> sendMailToUser(@RequestBody @Valid PasswordResetRequest request) {
		String content = findService.sendMailToUser(request);
		return ResponseEntity.ok(ApiResponse.success(content));
	}

	@Operation(summary = "비밀번호 재설정 인증코드 유효성 검사 api", description = "이메일로 받은 인증코드의 유효성을 체크")
	@GetMapping("/password/reset-verify")
	public ResponseEntity<ApiResponse<Map<String, Object>>> verifyResetToken(@RequestParam String token, @RequestParam String userName) {
		Map<String, Object> body = new HashMap<>();
		body = findService.verifyResetToken(token, userName);
		return ResponseEntity.ok(ApiResponse.success(body));
	}

	@Operation(summary = "비밀번호 재설정 api", description = "새로운 비밀번호 POST")
	@PostMapping("/password/reset")
	public ResponseEntity<ApiResponse<String>> resetPassword(@RequestBody @Valid NewPasswordPostRequest request) {
		String content = findService.resetPassword(request);
		return ResponseEntity.ok(ApiResponse.success(content));
	}

}
