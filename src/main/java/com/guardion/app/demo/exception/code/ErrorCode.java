package com.guardion.app.demo.exception.code;

import org.springframework.http.HttpStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ErrorCode {
	//user
	USER_NOT_FOUND(HttpStatus.NOT_FOUND, "U001", "사용자를 찾을 수 없습니다."),
	USERNAME_ALREADY_TAKEN(HttpStatus.BAD_REQUEST, "U002", "이미 사용중인 사용자 이름입니다."),

	//device
	DEVICE_NOT_FOUND(HttpStatus.NOT_FOUND, "D001", "장치를 찾을 수 없습니다."),
	NO_DEVICES_FOUND(HttpStatus.NOT_FOUND, "D002", "등록된 장치가 없습니다."),
	DEVICE_ALREADY_REGISTERED(HttpStatus.BAD_REQUEST, "D003", "이미 등록된 장치입니다."),

	//deviceData
	DEVICE_DATA_NOT_FOUND(HttpStatus.NOT_FOUND, "d004", "장치 데이터를 찾을 수 없습니다."),

	//alert
	NO_ALERTS_FOR_DEVICE(HttpStatus.NOT_FOUND, "A001", "해당 장치에 대한 알림이 없습니다."),

	//server
	INVALID_REQUEST(HttpStatus.BAD_REQUEST, "I001", "잘못된 요청입니다."),
	INVALID_INPUT(HttpStatus.BAD_REQUEST, "I002", "입력값이 올바르지 않습니다."),
	INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "S001", "서버 오류입니다."),

	//security
	INVALID_PASSWORD(HttpStatus.UNAUTHORIZED, "S001", "비밀번호가 일치하지 않습니다."),
	UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "S002", "인증되지 않은 사용자입니다."),

	//mqtt
	MQTT_CONNECTION_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "M001", "MQTT 연결 오류입니다."),
	MQTT_PUBLISH_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "M002", "MQTT 메시지 발행 오류입니다.");

	private final HttpStatus httpStatus;
	private final String code;
	private final String message;
}
