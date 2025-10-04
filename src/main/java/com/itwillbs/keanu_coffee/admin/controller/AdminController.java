package com.itwillbs.keanu_coffee.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.common.dto.SweetAlertIcon;
import com.itwillbs.keanu_coffee.common.utils.MakeAlert;
import com.mysql.cj.x.protobuf.MysqlxSession.AuthenticateContinue;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

	// 관리자페이지 메인
	@GetMapping("")
	public String adminMain() {

		return "/admin/admin_main";
	}

	// 직원관리
	@GetMapping("/employeeManage")
	public String employeeManagement() {
		return "redirect:/admin/employeeManagement";
	}

	// 조직관리
	@GetMapping("/preference/dept")
	public String systemPreference_organization() {

		return "redirect:/admin/systemPreference/dept";
	}

	// 공급업체관리
	@GetMapping("/preference/supplyCompany")
	public String systemPreference_supplyCompany() {

		return "redirect:/admin/systemPreference/supplyCompany";
	}

	// 상품관리
	@GetMapping("/preference/product")
	public String systemPreference_product() {

		return "redirect:/admin/systemPreference/product";
	}

	// 공급업체관리
	@GetMapping("/preference/supplyContract")
	public String systemPreference_supplyContract() {

		return "redirect:/admin/systemPreference/supplyContract";
	}

	// 지점관리
	@GetMapping("/preference/franchise")
	public String systemPreference_franchise() {
		return "redirect:/admin/systemPreference/franchise";
	}

	// 로그
	@GetMapping("/workingLog")
	public String workingTree() {
		return "redirect:/workingLog";
	}

	// 대시보드
	@GetMapping("/dash")
	public String dashboard() {
		return "redirect:/statistics/1";
	}
	
	//알림페이지
	@GetMapping("/sysNoti")
	public String systemNotification() {
		return "redirect:/admin/systemnotification";
	}

}
