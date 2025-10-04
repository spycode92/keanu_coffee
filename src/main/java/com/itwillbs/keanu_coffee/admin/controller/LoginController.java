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

//@Controller
@AllArgsConstructor
public class LoginController {
	private final LoginService loginService;
	private final EmployeeManagementService employeeManagementService;
	private final FileService fileService;

	@GetMapping("/main")
	public String main() {

		return "main";
	}
}
