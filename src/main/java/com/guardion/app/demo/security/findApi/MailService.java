package com.guardion.app.demo.security.findApi;

import java.nio.charset.StandardCharsets;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.guardion.app.demo.security.dto.PasswordResetRequest;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MailService {
	private final JavaMailSender mailSender;

	@Value("${mail.from}")
	private String fromAddress;

	@Value("${mail.reset-base-url}")
	private String resetBaseUrl;

	public void sendVerificationCodeMail(String name, String email) {

		if (email == null || email.isBlank()) {
			throw new IllegalArgumentException("이메일 주소가 누락되었음");
		}

		String resetToken = UUID.randomUUID().toString();
		String resetLink = String.format("%s?token=%s", resetBaseUrl, resetToken);

		String subject = "[Guardion] 비밀번호 재설정 안내";
		String html = """
                <div style='font-family:system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;font-size:14px;line-height:1.6'>
                  <p>안녕하세요, %s 님.</p>
                  <p>비밀번호 재설정을 요청하셨습니다. 아래 버튼을 눌러 재설정 페이지로 이동하십시오.</p>
                  <p style='margin:24px 0'>
                    <a href='%s' style='display:inline-block;padding:10px 16px;text-decoration:none;border:1px solid #222'>비밀번호 재설정하기</a>
                  </p>
                  <p>만약 본인이 요청하지 않았다면, 이 메일은 무시하셔도 됩니다.</p>
                  <p style='color:#666'>보안상 링크는 일정 시간 이후 만료될 수 있습니다.</p>
                </div>
                """.formatted(name,resetLink);

		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());
			helper.setFrom(fromAddress);
			helper.setTo(email);
			helper.setSubject(subject);
			helper.setText(html, true);
			mailSender.send(message);
		} catch (MessagingException e) {
			throw new RuntimeException("메일 전송 실패: " + e.getMessage(), e);
		}
	}
}
