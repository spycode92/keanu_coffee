package com.itwillbs.keanu_coffee.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {
	
	//관리자페이지 메인
	@GetMapping("")
	public String adminMain(HttpSession session, Model model) {
		
		if(!session.getAttribute("sId").equals("admin")) {
			model.addAttribute("msg", "권한이 없습니다.");
			model.addAttribute("targetURL", "/"); 
			return "/commons/result_process";
		}
		
		return "/admin/admin_main";
	}
	
	@GetMapping("/employeeManagement")
	public String EmployeeManagement() {
		
		return "/admin/employee_management";
	}
	
	@GetMapping("/accessManagement")
	public String AccessManagementcontroller() {
		
		return "/admin/access_management";
	}
	
	@GetMapping("/log")
	public String workingTree() {
		return "redirect:/admin/workingLog";
	}

	@GetMapping("/dash")
	public String Dashboard() {
		return "redirect:/admin/dashboard";
	}
	
	
}
