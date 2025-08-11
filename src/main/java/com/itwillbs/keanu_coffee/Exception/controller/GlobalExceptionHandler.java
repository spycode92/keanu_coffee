package com.itwillbs.keanu_coffee.Exception.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.itwillbs.keanu_coffee.Exception.service.CustomNotFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
	private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);
	
	
	// 모든 예외 처리
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleAllExceptions(Exception ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        		.header("Content-Type", "text/plain; charset=UTF-8")
                .body("서버 내부 오류가 발생했습니다. 관리자에게 문의하세요.");
    }
    
	//특정 사용자 정의 예외 처리
	@ExceptionHandler(CustomNotFoundException.class)
	public ResponseEntity<String> handleNotFoundException(CustomNotFoundException ex) {
        log.warn("발생에러 : " + ex.getMessage());
        log.warn("발생이유 : " + ex.getCause());
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
        		.header("Content-Type", "text/plain; charset=UTF-8")
        		.body(ex.getMessage());
    }
}
