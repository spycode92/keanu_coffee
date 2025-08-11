package com.itwillbs.keanu_coffee.Exception.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.itwillbs.keanu_coffee.Exception.service.CustomNotFoundException;

@RestController
@RequestMapping("/test")
public class ExceptionTestController {

    // 1. CustomNotFoundException 테스트용 엔드포인트
    @GetMapping("/notfound")
    public String testNotFound() {
        throw new CustomNotFoundException("해당 리소스를 찾을 수 없습니다.");
    }

    // 2. NullPointerException 같은 일반 예외 테스트용 엔드포인트
    @GetMapping("/general")
    public String testGeneralError() {
        String str = null;
        str.length(); // NullPointerException 발생
        return "OK";
    }
}