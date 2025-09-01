package com.itwillbs.keanu_coffee;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.security.sasl.AuthenticationException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.HttpStatusCodeException;

import com.itwillbs.keanu_coffee.admin.service.LoginService;

import lombok.RequiredArgsConstructor;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequiredArgsConstructor
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private final LoginService loginService;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		return "home";
	}
	
	@GetMapping("/testHttpStatusCodeException")
	public String testHttpStatusCodeException() {
	    throw new HttpStatusCodeException(HttpStatus.BAD_REQUEST) {}; // 익명 서브클래스 이용해 강제 발생
	}
	
	@GetMapping("/testValidationException")
	public String testValidationException() throws BindException {
	    BindException ex = new BindException(new Object(), "target");
	    throw ex;
	}
	
	@GetMapping("/testAccessDeniedException")
	public String testAccessDeniedException() {
	    throw new AccessDeniedException("접근 권한이 없습니다.");
	}
	
	@GetMapping("/testAuthenticationException")
	public String testAuthenticationException() throws AuthenticationException {
	    throw new AuthenticationException("인증 실패") {};
	}
	
	@GetMapping("/testDataIntegrityViolationException")
	public String testDataIntegrityViolationException() {
	    throw new DataIntegrityViolationException("데이터 무결성 위반");
	}
	@GetMapping("/testGenericException")
	public String testGenericException() {
	    throw new RuntimeException("알 수 없는 예외 발생");
	}
	
}
