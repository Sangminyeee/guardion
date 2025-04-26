package com.guardion.app.demo.exception.code;

import org.springframework.http.HttpStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum SuccessCode {

	SUCCESS(HttpStatus.OK, "S200", "요청이 성공적으로 처리되었습니다."),
	CREATED(HttpStatus.CREATED, "S201", "리소스가 성공적으로 생성되었습니다.");

	private final HttpStatus httpStatus;
	private final String code;
	private final String message;
}
