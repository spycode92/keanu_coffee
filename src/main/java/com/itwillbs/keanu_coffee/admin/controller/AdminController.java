package com.itwillbs.keanu_coffee.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {
	
	//관리자페이지 메인
	@GetMapping("/main")
	public String adminMain(HttpSession session, Model model) {
		
		if(!session.getAttribute("EmployeePosition").equals("admin")) {
			model.addAttribute("msg", "권한이 없습니다.");
			model.addAttribute("targetURL", "/"); 
			return "/commons/result_process";
		}
		
		return "/admin/admin_main";
	}
	
	@GetMapping("/employeeManagement")
	public String EmployeeManagement() {
		return "/admin/employee_management/employeeManagement";
	}
	
	
}
