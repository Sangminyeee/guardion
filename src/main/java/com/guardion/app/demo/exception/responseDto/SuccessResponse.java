package com.guardion.app.demo.exception.responseDto;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.guardion.app.demo.exception.code.ErrorCode;
import com.guardion.app.demo.exception.code.SuccessCode;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class SuccessResponse<T> {

	private final boolean success;
	private final String code;
	private final String message;
	private final T data;

	public static <T> SuccessResponse<T> success(T data) {
		return new SuccessResponse<>(true, SuccessCode.SUCCESS.getCode(),
			SuccessCode.SUCCESS.getMessage(), data);
	}

	public static SuccessResponse<Void> successWithNoData() {
		return new SuccessResponse<>(true, SuccessCode.SUCCESS.getCode(),
			SuccessCode.SUCCESS.getMessage(), null);
	}

	public static <T> SuccessResponse<T> created(T data) {
		return new SuccessResponse<>(true, SuccessCode.CREATED.getCode(),
			SuccessCode.CREATED.getMessage(), data);
	}

	public static SuccessResponse<Void> createdWithNoData() {
		return new SuccessResponse<>(true, SuccessCode.CREATED.getCode(),
			SuccessCode.CREATED.getMessage(), null);
	}
}

