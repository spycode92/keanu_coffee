package com.itwillbs.keanu_coffee.outbound.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundManagementDTO;
import com.itwillbs.keanu_coffee.outbound.service.OutboundService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/outbound")
public class OutboundController {
	
	private final OutboundService outboundService; 
	
	// 대시보드
	@GetMapping("/main")
	public String showOutboundDashboard() {
		return "/outbound/outboundDashboard";
	}
	
	// 출고조회
	@GetMapping("/outboundManagement")
	public String showOutboundManagement(Model model) {
		// 출고 리스트 조회
		List<OutboundManagementDTO> obManagement = outboundService.getAllObManagementList();
		model.addAttribute("obManagement", obManagement);
		
	    return "/outbound/outboundManagement";
	}
	
	// 출고상세페이지
	@GetMapping("/outboundDetail")
	public String showOutboundDetail() {
	    return "/outbound/outboundDetail";
	}
	
	// 출고요청
	@GetMapping("/outboundRegister")
	public String showOutboundRegister() {
		return "/outbound/outboundRegister";
	}
	
	// 출고검수
	@GetMapping("/outboundInspection")
	public String showOutboundInspection() {
		return "/outbound/outboundInspection";
	}
	
	// 출고피킹
	@GetMapping("/outboundPicking")
	public String showOutboundPicking() {
		return "/outbound/outboundPicking";
	}
	
	// 출고확정
	@GetMapping("/outboundConfirm")
	public String showOutboundConfirm() {
		return "/outbound/outboundConfirm";
	}
	

}
