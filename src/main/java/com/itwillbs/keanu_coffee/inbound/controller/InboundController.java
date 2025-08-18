package com.itwillbs.keanu_coffee.inbound.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	// 대시보드
	@GetMapping("/main")
	public String showInboundDashboard() {
		return "/inbound/inboundDashboard";
	}
	
	// 입고조회
	@GetMapping("/management")
	public String showInboundManagement() {
		return "/inbound/inboundManagement";
	}
	
	// 입고상세
	@GetMapping("/inboundDetail")
	public String showInboundDetail() {
		return "/inbound/inboundDetail";
	}
	
	// 입고등록
	@GetMapping("/inboundRegister")
	public String showInboundRegister() {
		return "/inbound/inboundRegister";
	}
	
	// 입고확정
	@GetMapping("/inboundConfirm")
	public String showInboundConfirm() {
		return "/inbound/inboundConfirm";
	}
	
	// 입고검수
	@GetMapping("/inboundInspection")
	public String showInboundInspection() {
		return "/inbound/inboundInspection";
	}
	
}
