package com.itwillbs.keanu_coffee.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference")
public class SystemPreferencesController {
	
	@GetMapping("")
	public String systemPreference() {
		
		return "/admin/system_preferences";
	}
	
}
