package com.guardion.app.demo.security.enterApi;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.exception.responseDto.ApiResponse;
import com.guardion.app.demo.repository.UserRepository;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.security.JwtProvider;
import com.guardion.app.demo.security.dto.LoginRequest;
import com.guardion.app.demo.security.dto.SignupRequest;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
public class EnterController {

	private final UserRepository userRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtProvider jwtProvider;
	private final EnterService enterService;

	@PostMapping("/signup")
	public ResponseEntity<ApiResponse<Void>> register(@RequestBody @Valid SignupRequest request) {
		enterService.enter(request);
		return ResponseEntity.ok(ApiResponse.successWithNoData());
	}

	@PostMapping("/login")
	public ResponseEntity<Map<String, String>> login(@RequestBody @Valid LoginRequest request) {
		String token = enterService.login(request);
		return ResponseEntity.ok()
			.header("Authorization", "Bearer " + token)
			.body(Map.of("message", "Login successful", "token", token));
	}
}
