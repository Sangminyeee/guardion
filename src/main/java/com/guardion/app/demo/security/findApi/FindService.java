package com.guardion.app.demo.security.findApi;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.guardion.app.demo.domain.PasswordResetToken;
import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.PasswordResetTokenRepository;
import com.guardion.app.demo.repository.UserRepository;
import com.guardion.app.demo.security.TokenHash.HashUtils;
import com.guardion.app.demo.security.TokenHash.TokenUtils;
import com.guardion.app.demo.security.dto.PasswordResetRequest;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FindService {

	private final MailService mailService;
	private final UserRepository userRepository;
	private final PasswordResetTokenRepository tokenRepository;

	@Value("${mail.reset-base-url}")
	private String resetBaseUrl;
	@Value("${app.reset-token.ttl-minutes}")
	private long ttlMinutes;

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
				.userId(user.getId())
				.tokenHash(hash)
				.expiresAt(expiresAt)
				.build();

		// 4) 업서트 저장(사용자당 1개만 유효)
		tokenRepository.save(token);

		// 5) 링크 구성(프론트 라우트 기준 예시)
		//    필요하면 uid를 함께 전달하거나, 프런트가 이후 /reset-verify에서 이메일을 다시 적게 할 수도 있다.
		String link = resetBaseUrl
			+ "?token=" + URLEncoder.encode(plain, StandardCharsets.UTF_8)
			+ "&uid=" + user.getId();

		mailService.sendVerificationCodeMail(request.getUsername(), request.getEmail(), link);
		return "메일이 성공적으로 전송되었습니다.";
	}
}

