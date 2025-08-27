package com.guardion.app.demo.security.findApi;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.guardion.app.demo.security.dto.PasswordResetRequest;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FindService {

	private final MailService mailService;

	public String sendMailToUser(@Valid PasswordResetRequest request) {
		mailService.sendVerificationCodeMail(request.getUsername(), request.getEmail());
		return "메일이 성공적으로 전송되었습니다.";
	}
}

