package com.itwillbs.keanu_coffee.common.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;

@Component
public class RedirectDecider {
	public String decideRedirectUrl(Authentication authentication) {
		// 인증 정보 중 아이디 가져오기
		String empNo = authentication.getName();
		// 인증 정보를 MyUserDetails 객체로 변환 => getPrincipal() 메서드로 Principal 객체 얻어와서 변환
		EmployeeDetail employeeDetail = (EmployeeDetail)authentication.getPrincipal();
		
		String roleName = employeeDetail.getRole().getRoleName();
		String redirectURL = "/";
		switch(roleName) {
			case "최고관리자" : redirectURL = "/admin/dash"; break;
			case "시스템관리자" : redirectURL = "/admin/systemPreference/dept"; break;
			case "입고관리자" : redirectURL = "/inbound/main"; break;
			case "입고평사원" : redirectURL = "/inbound/management"; break;
			case "출고관리자" : redirectURL = "/outbound/main"; break;
			case "출고평사원" : redirectURL = "/outbound/outboundManagement"; break;
			case "재고관리자" : redirectURL = "/inventory/main"; break;
			case "재고평사원" : redirectURL = "/inventory/moveInventory"; break;
			case "운송관리자" : redirectURL = "/transport/main"; break;
			case "운송기사" : redirectURL = "/transport/mypage/" + empNo;
		}
		
		return redirectURL;
	}
}