package com.itwillbs.keanu_coffee.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.LoginService;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.service.FileService;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class LoginController {
	private final LoginService loginService;
	private final EmployeeManagementService employeeManagementService;
	private final FileService fileService;
	
	@PostMapping("/login")
	public String login(EmployeeInfoDTO employee, Model model, HttpSession session) {
		
		boolean checkPassword = loginService.checkPassword(employee);
		// 로그인 실패시
		if(checkPassword == false) {
			model.addAttribute("msg", "로그인 실패");
			model.addAttribute("targetURL", "/"); 
			return "/commons/result_process";
		}
		
		employee = employeeManagementService.getEmployeeInfo(employee);
		FileDTO file = fileService.getFile("employee_info", employee.getIdx());
		
		// 아이디 비밀번호 일치, 상태 = 재직
		//로그인 성공시 아이디, 이름, 포지션 저장
		if(employee.getEmpStatus().equals("재직")) {
			
			session.setAttribute("sIdx", employee.getIdx());
			session.setAttribute("sId", employee.getEmpId());
			session.setAttribute("sName", employee.getEmpName());
			session.setAttribute("sPosition", employee.getRoleIdx());
		
		// 프로필사진
		if (file != null) {
		    session.setAttribute("sFIdx", file.getIdx());
		}
		
		//임시 세션만료시간 1일
		session.setMaxInactiveInterval(60 * 60 * 24);
		
		return "redirect:/main";
		}
		
		// 재직중이 아닌 사원
		model.addAttribute("msg", "시스템사용 권한이 없습니다.");
		model.addAttribute("targetURL", "/"); 
		return "/commons/result_process";
	}
	
	
	//로그아웃시 세션만료
	@GetMapping("logout")
	public String logout(HttpSession session) {
		if (session != null) {
	        session.invalidate(); // 세션 자체를 무효화
	    }
		
		return "redirect:/";
	}
	
	
	
	@GetMapping("/main")
	public String main() {

		return "main";
	}
}
