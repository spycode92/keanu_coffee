package com.itwillbs.keanu_coffee.common.dto;

public class CustomBusinessException extends RuntimeException {
	public CustomBusinessException(String message) {
        super(message);
    }
}
