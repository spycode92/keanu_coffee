package com.itwillbs.keanu_coffee.common.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.common.dto.SweetAlertIcon;
import com.itwillbs.keanu_coffee.common.utils.MakeAlert;

import lombok.extern.log4j.Log4j2;

@ControllerAdvice
@Log4j2
public class MyExceptionHandler {
	

	 /**
     * HTTP 요청 중 서버에서 오류 상태 코드가 발생한 경우 처리
     */
    @ExceptionHandler(HttpStatusCodeException.class)
    public String handleHttpStatusCodeException(HttpStatusCodeException e, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
        log.info("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
    	log.error("HttpStatusCodeException: {}", e.getMessage(), e);
    	log.info("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑");
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
        MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "서버 오류", "서버 요청 처리 중 오류가 발생했습니다.");
        return redirectBackOrRoot(request);
    }
    
    /**
     * 유효성 검사 실패 (폼 입력 검증 오류) 처리
     */
    @ExceptionHandler({BindException.class, MethodArgumentNotValidException.class})
    public String handleValidationException(Exception e, HttpServletRequest request, RedirectAttributes redirectAttributes) {
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
    	log.info("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
    	log.warn("Validation Failed: {}", e.getMessage());
    	log.info("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑");
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
        MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.WARNING, "입력 오류", "입력값이 올바르지 않습니다. 다시 확인해주세요.");
        return redirectBackOrRoot(request);
    }

    /**
     * 권한 부족 (Access Denied) 예외 처리
     */
    @ExceptionHandler(AccessDeniedException.class)
    public String handleAccessDeniedException(AccessDeniedException e, HttpServletRequest request, RedirectAttributes redirectAttributes) {
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
    	log.info("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
    	log.warn("Access Denied: {}", e.getMessage());
    	log.info("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑");
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
        MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "권한 없음", "해당 기능에 접근할 권한이 없습니다.");
        return redirectBackOrRoot(request);
    }

    /**
     * 인증 실패(로그인 실패) 예외 처리
     */
    @ExceptionHandler(AuthenticationException.class)
    public String handleAuthenticationException(AuthenticationException e, HttpServletRequest request, RedirectAttributes redirectAttributes) {
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
    	log.info("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
    	log.warn("Authentication Failed: {}", e.getMessage());
    	log.info("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑");
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
        MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "인증 실패", "로그인이 필요합니다.");
        return redirectBackOrRoot(request);
    }

    /**
     * DB 제약 조건 위반 등 데이터 무결성 오류 처리
     */
    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrityViolationException(DataIntegrityViolationException e, HttpServletRequest request, RedirectAttributes redirectAttributes) {
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
    	log.info("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
    	log.error("Data integrity violation: {}", e.getMessage(), e);
    	log.info("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑");
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
        MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "데이터 오류", "데이터 처리 중 오류가 발생했습니다.");
        return redirectBackOrRoot(request);
    }

    /**
     * 기타 모든 예외 처리 (최상위 예외 처리)
     */
    @ExceptionHandler(Exception.class)
    public String handleGenericException(Exception e, HttpServletRequest request, RedirectAttributes redirectAttributes) {
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
    	log.info("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓");
    	log.error("Unexpected Exception: {}", e.getMessage(), e);
    	log.info("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑");
    	log.info("ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR");
        MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "오류 발생", "예기치 못한 오류가 발생했습니다. 관리자에게 문의하세요.");
        return redirectBackOrRoot(request);
    }

    /**
     * 요청이 왔던 referer 주소로 리다이렉트하거나 없으면 루트("/")로 리다이렉트하는 공통 메서드
     */
    private String redirectBackOrRoot(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        } else {
            return "redirect:/";
        }
    }
}
