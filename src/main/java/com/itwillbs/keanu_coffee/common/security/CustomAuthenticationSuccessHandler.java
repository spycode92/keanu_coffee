package com.itwillbs.keanu_coffee.common.security;

import java.io.IOException;
import java.security.Principal;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

// 스프링 시큐리티로 로그인 성공 시 작업을 처리할 핸들러
// => AuthenticationSuccessHandler 구현체 형태로 정의
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
	
	// 로그인 성공 시 자동으로 호출되는 onAuthenticationSuccess() 메서드에 
	//별도의 추가 작업(ex. 아이디 기억하기, 읽지않은 메세지 확인, 권한별 이동 페이지 구분 등)을 구현
	@Override
	public void onAuthenticationSuccess(
			HttpServletRequest request // 요청정보
			, HttpServletResponse response // 응답정보
			, Authentication authentication // 인증정보
				) throws IOException, ServletException {
		
		// 인증 정보 중 아이디 가져오기
		String empNo = authentication.getName();
		// 인증 정보를 MyUserDetails 객체로 변환 => getPrincipal() 메서드로 Principal 객체 얻어와서 변환
		EmployeeDetail employeeDetail = (EmployeeDetail)authentication.getPrincipal();
		
		
		String roleName = employeeDetail.getRole().getRoleName();
		String redirectURL = "/main";
		switch(roleName) {
			case "최고관리자" : redirectURL = "/admin/dash";
			case "시스템관리자" : redirectURL = "/admin/systemPreference/dept";
			case "입고관리자" : redirectURL = "/inbound/main";
			case "입고평사원" : redirectURL = "/inbound/management";
			case "출고관리자" : redirectURL = "/outbound/main";
			case "출고평사원" : redirectURL = "/outbound/management";
			case "재고관리자" : redirectURL = "/inventory/main";
			case "재고평사원" : redirectURL = "/inventory//inventory/inventoryToMove";
			case "운송관리자" : redirectURL = "/transport/main";
			case "운송기사" : redirectURL = "/transport/myPage/" + empNo;
		}
		// 사용자 권한 확인
		if(employeeDetail.getRole().getRoleName().contains("최고관리자")) { // 관리자 권한들(ADMIN, ADMIN_2, ...)
			response.sendRedirect("/admin/dash");
		} else { // 일반 사용자 권한
			// 로그인 폼으로 이동 시 직전 페이지 이동시키기
			HttpSession session = request.getSession();
			String prevPage = (String)session.getAttribute("prevPage"); //이전경로가져오기
			session.removeAttribute("prevPage"); // 이전경로 기록 제거 
			
			// 이전 경로가 있을 경우 이전 경로로 리다이렉트, 아니면 메인페이지로 리다이렉트
			String redirectURL = "/";
			
			if(prevPage != null) { // 이전 경로 있을 경우 루트("/") 대신 이전 경로로 교체
				redirectURL = prevPage; // 주의! redirect:뒤에 슬래시(/) 붙이지 않는다
			}
			
			response.sendRedirect(redirectURL);
			
		}
		
		
	}

}
