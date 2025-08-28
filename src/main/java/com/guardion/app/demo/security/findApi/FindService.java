package com.guardion.app.demo.security.findApi;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.guardion.app.demo.domain.User;
import com.guardion.app.demo.exception.BusinessException;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.repository.UserRepository;
import com.guardion.app.demo.security.dto.PasswordResetRequest;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FindService {

	private final MailService mailService;
	private final UserRepository userRepository;

	public String sendMailToUser(@Valid PasswordResetRequest request) {
		User user = userRepository.findByUsernameAndEmail(request.getUsername(), request.getEmail())
			.orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
		mailService.sendVerificationCodeMail(request.getUsername(), request.getEmail());
		return "메일이 성공적으로 전송되었습니다.";
	}
}

