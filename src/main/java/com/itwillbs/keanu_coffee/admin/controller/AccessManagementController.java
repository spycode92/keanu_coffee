package com.itwillbs.keanu_coffee.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/accessManagementController")
public class AccessManagementController {
	@GetMapping("/")
	public String AccessManagementcontroller() {
		
		return "/admin/access_management";
	}
	
}
