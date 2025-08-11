package com.itwillbs.keanu_coffee.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.LoginService;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class LoginController {
	private final LoginService loginService;
	private final EmployeeManagementService employeeManagementService;
		
	@PostMapping("/login")
	public String login(EmployeeDTO employee, Model model, HttpSession session) {
		System.out.println("컨트롤러");
		System.out.println(employee.getEmpPassword());
		
		boolean checkPassword = loginService.checkPassword(employee);
		// 로그인 실패시
		if(checkPassword == false) {
			model.addAttribute("msg", "로그인 실패");
			model.addAttribute("targetURL", "/"); 
			return "/commons/result_process";
		}
		
		employee = employeeManagementService.getEmployeeInfo(employee);
		
		//로그인 성공시 아이디, 포지션 저장
		session.setAttribute("Sid", employee.getEmpId());
		session.setAttribute("EmployeePosition", employee.getEmpPosition());
		
		return "redirect:/main";
	}
	
	@GetMapping("/main")
	public String main() {

		return "main";
	}
}
