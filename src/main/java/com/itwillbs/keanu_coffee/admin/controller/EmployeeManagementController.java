package com.itwillbs.keanu_coffee.admin.controller;

import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/employeeManagement")
public class EmployeeManagementController {
	private final EmployeeManagementService employeeManagementService;
	
	//관리자페이지 회원추가폼으로 이동
	@GetMapping("/addEmployeeForm")
	public String addEmployeeForm() {
		return "/admin/popup/add_employee_form";
	}
		
	
	//관리자페이지 회원추가 로직
	@PostMapping("/addEmployee")
	public String addEmployeeForm(EmployeeInfoDTO employee, Model model) throws IOException {
		// 
		int inputCount = employeeManagementService.inputEmployeeInfo(employee);
		if (inputCount == 0) {
			model.addAttribute("msg", "추가실패");
		}
		model.addAttribute("msg", "추가완료");
		model.addAttribute("targetURL", "/admin/employeeManagement/addEmployeeForm"); 
		return "/commons/result_process";
//		return "";
	}
	
	//직원 개인정보 변경폼
	
	
	
}
