package com.itwillbs.keanu_coffee.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mysql.cj.x.protobuf.MysqlxSession.AuthenticateContinue;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {
	
	//관리자페이지 메인
	@GetMapping("")
	public String adminMain(HttpSession session, Model model, Authentication authentication) {
		String id = authentication.getName();
		if(!id.equals("admin")) {
			model.addAttribute("msg", "권한이 없습니다.");
			model.addAttribute("targetURL", "/"); 
			return "/commons/result_process";
		}
		
		return "/admin/admin_main";
	}
	//직원관리
	@GetMapping("/employeeManage")
	public String employeeManagement() {
		
		return "redirect:/admin/employeeManagement";
	}
	//조직관리
	@GetMapping("/preference/dept")
	public String systemPreference_organization() {
		
		return "redirect:/admin/systemPreference/dept";
	}
	//공급업체관리
	@GetMapping("/preference/supplyCompany")
	public String systemPreference_supplyCompany() {
		
		return "redirect:/admin/systemPreference/supplyCompany";
	}
	//상품관리
	@GetMapping("/preference/product")
	public String systemPreference_product() {
		
		return "redirect:/admin/systemPreference/product";
	}
	//공급업체관리
	@GetMapping("/preference/supplyContract")
	public String systemPreference_supplyContract() {
		
		return "redirect:/admin/systemPreference/supplyContract";
	}
	
	//지점관리
	@GetMapping("/preference/franchise")
	public String systemPreference_franchise() {
		return "redirect:/admin/systemPreference/franchise";
	}
	
	//로그
	@GetMapping("/log")
	public String workingTree() {
		return "redirect:/admin/workingLog";
	}
	
	//대시보드
	@GetMapping("/dash")
	public String dashboard() {
		return "redirect:/admin/dashboard";
	}
	
	//
	@GetMapping("/moveInventory")
	public String moveInventory() {
		return "/admin/employee_management/move_inventory";
	}
	
	
}
