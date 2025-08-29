package com.guardion.app.demo.security.findApi;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.guardion.app.demo.domain.PasswordResetToken;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.PasswordResetTokenRepository;
import com.guardion.app.demo.repository.UserRepository;
import com.guardion.app.demo.security.TokenHash.HashUtils;
import com.guardion.app.demo.security.TokenHash.TokenUtils;
import com.guardion.app.demo.security.dto.NewPasswordPostRequest;
import com.guardion.app.demo.security.dto.PasswordResetRequest;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FindService {

	private final MailService mailService;
	private final UserRepository userRepository;
	private final PasswordResetTokenRepository tokenRepository;
	private final PasswordEncoder passwordEncoder;

	@Value("${mail.reset-base-url}")
	private String resetBaseUrl;
	@Value("${app.reset-token.ttl-minutes}")
	private long ttlMinutes;

	@Transactional
	public String sendMailToUser(@Valid PasswordResetRequest request) {
		User user = userRepository.findByUsernameAndEmail(request.getUsername(), request.getEmail())
			.orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

		// 1) 평문 토큰 생성
		String plain = TokenUtils.randomUrlSafeToken(48);

		// 2) 해시 계산
		byte[] hash = HashUtils.sha256(plain);

		// 3) 만료 시각
		LocalDateTime expiresAt = LocalDateTime.now().plus(Duration.ofMinutes(ttlMinutes));

		PasswordResetToken token =
			PasswordResetToken.builder()
				.userName(user.getUsername())
				.tokenHash(hash)
				.expiresAt(expiresAt)
				.build();

		// 4) 업서트 저장(사용자당 1개만 유효)
		tokenRepository.save(token);

		// 5) 링크 구성(프론트 라우트 기준 예시)
		//    필요하면 uid를 함께 전달하거나, 프런트가 이후 /reset-verify에서 이메일을 다시 적게 할 수도 있다.
		String link = resetBaseUrl
			+ "?token=" + URLEncoder.encode(plain, StandardCharsets.UTF_8)
			+ "&uName=" + user.getUsername();

		mailService.sendVerificationCodeMail(request.getUsername(), request.getEmail(), link);
		return "메일이 성공적으로 전송되었습니다.";
	}

	@Transactional
	public Map<String, Object> verifyResetToken(String plainToken, String userName) {
		byte[] presentedHash = HashUtils.sha256(plainToken);
		var t = tokenRepository.findByUserNameAndTokenHash(userName, presentedHash);

		if (t.isEmpty()) {
			return returnInvalid("token not found");
		}
		var token = t.get();
		if (token.getUsedAt() != null) {
			return returnInvalid("used token");
		}
		if (token.getExpiresAt().isBefore(LocalDateTime.now())) {
			return returnInvalid("expired token");
		}

		// 성공: 토큰 사용 처리(재사용 방지)
		token.setUsedAt(LocalDateTime.now());
		tokenRepository.save(token);

		return returnValid();
	}

	public Map<String, Object> returnValid() {
		return Map.of(
			"valid", true
		);
	}
	public Map<String, Object> returnInvalid(String reason) {
		Map<String, Object> body = new LinkedHashMap<>();
		body.put("valid", false);
		body.put("reason", reason);
		return body;
	}

	@Transactional
	public String resetPassword(NewPasswordPostRequest request) {
		User user = userRepository.findByUsername(request.getUsername())
			.orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));

		user.setPassword(passwordEncoder.encode(request.getNewPassword()));
		user.setTokenVersion(user.getTokenVersion() + 1);
		userRepository.save(user);

		return "비밀번호가 성공적으로 변경되었습니다.";
	}
}

