package com.guardion.app.demo.security.enterApi;

import static java.time.LocalTime.*;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Base64;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.domain.PendingUser;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.eunms.UserRole;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.PendingUserRepository;
import com.guardion.app.demo.repository.UserRepository;
import com.guardion.app.demo.security.JwtProvider;
import com.guardion.app.demo.security.dto.LoginRequest;
import com.guardion.app.demo.security.dto.SignupCodeRequest;
import com.guardion.app.demo.security.dto.SignupVerifyRequest;
import com.guardion.app.demo.security.findApi.MailService;
import com.guardion.app.demo.security.findApi.PendingUserService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EnterService {

	private final UserRepository userRepository;
	private final PasswordEncoder passwordEncoder;
	private final JwtProvider jwtProvider;
	private final PendingUserRepository pendingUserRepository;
	private final MailService mailService;
	private final PendingUserService pendingUserService;

	@Value("${app.reset-token.ttl-minutes}")
	private long ttlMinutes;

	@Transactional
	public String sendCode(SignupCodeRequest request) {
		if (userRepository.existsByUsername(request.getUsername())) {
			throw new BusinessException(ErrorCode.USERNAME_ALREADY_TAKEN);
		} else if (userRepository.existsByEmail(request.getEmail())) {
			throw new BusinessException(ErrorCode.EMAIL_ALREADY_TAKEN);
		}

		String code = generate6Digits();        // "031942"
		String codeHash = sha256(code);
		String pwdHash  = passwordEncoder.encode(request.getPassword());

		LocalDateTime expiresAt = LocalDateTime.now().plus(Duration.ofMinutes(ttlMinutes));
		pendingUserRepository.save(request.toPendingUser(pwdHash, codeHash, expiresAt));

		mailService.sendOtpCode(request.getEmail(), "[Guardion] 회원가입 인증코드", "인증 코드: " + code + "\n유효시간: 10분");

		return "인증코드가 이메일로 전송되었습니다.";
	}

	@Transactional
	public String verifyCode(SignupVerifyRequest request) {
		PendingUser p = pendingUserRepository.findByEmail(request.getEmail())
			.orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND)); //변경필요
		if (now().isAfter(p.getExpiresAt().toLocalTime())) {
			pendingUserService.deletePendingUser(p);
			throw new IllegalStateException("인증코드가 만료됨.");
		}
		if (p.getAttempts() >= 5) {
			pendingUserService.deletePendingUser(p);
			throw new IllegalStateException("인증코드 검증 시도 횟수 초과.");
		}
		if (!sha256(request.getCode()).equals(p.getCode())) {
			pendingUserService.increaseAttempts(p);
			throw new IllegalArgumentException("인증코드 불일치. 누적 시도 횟수: " + p.getAttempts());
		}

		User u = User.builder()
			.email(p.getEmail())
			.username(p.getUsername())
			.password(p.getPassword())
			.birthDate(p.getBirthDate())
			.findUsernameHashCodeAttempts(0)
			.tokenVersion(0)
			.role(UserRole.VIEWER)
			.build();
		userRepository.save(u);

		pendingUserRepository.delete(p);

		return "회원가입이 완료되었습니다.";
	}

	@Transactional
	public String login(LoginRequest request) {
		User user = userRepository.findByUsername(request.getUsername())
			.orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

		if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
			throw new BusinessException(ErrorCode.INVALID_PASSWORD);
		}

		return jwtProvider.createToken(user.getUsername(), user.getRole().name(), user.getTokenVersion());
	}

	private String generate6Digits() {
		return String.format("%06d", new SecureRandom().nextInt(1_000_000));
	}

	private String sha256(String input) {
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
			return Base64.getEncoder().encodeToString(hash);
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException(e);
		}
	}
}
