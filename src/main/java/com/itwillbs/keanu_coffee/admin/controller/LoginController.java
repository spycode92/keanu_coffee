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
		FileDTO file = fileService.getFile(employee.getEmpNo(), "");
		
		//로그인 성공시 아이디, 이름, 포지션 저장
		session.setAttribute("sId", employee.getEmpId());
		session.setAttribute("sName", employee.getEmpName());
		session.setAttribute("sPosition", employee.getEmpPosition());
		if (file != null) {
		    session.setAttribute("sFid", file.getFileId());
		}
		//임시 세션만료시간 1일
		session.setMaxInactiveInterval(60 * 60 * 24);
		
		return "redirect:/main";
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
