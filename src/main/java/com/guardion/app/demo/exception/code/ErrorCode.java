package com.guardion.app.demo.exception.code;

import org.springframework.http.HttpStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {

	USER_NOT_FOUND(HttpStatus.NOT_FOUND, "U001", "사용자를 찾을 수 없습니다."),
	DEVICE_NOT_FOUND(HttpStatus.NOT_FOUND, "D001", "장치를 찾을 수 없습니다."),
	INVALID_REQUEST(HttpStatus.BAD_REQUEST, "C001", "잘못된 요청입니다."),
	INVALID_INPUT(HttpStatus.BAD_REQUEST, "C002", "입력값이 올바르지 않습니다."),
	INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "S001", "서버 오류입니다.");

	private final HttpStatus httpStatus;
	private final String code;
	private final String message;
}
