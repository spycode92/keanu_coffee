package com.itwillbs.keanu_coffee.inbound.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.admin.service.ProductService;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.service.PurchaseOrderService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	private final PurchaseOrderService purchaseOrderService;
	
	// 대시보드
	@GetMapping("/main")
	public String showInboundDashboard() {
		return "/inbound/inboundDashboard";
	}
	
	// 입고조회
	@GetMapping("/management")
	public String showInboundManagement(Model model) {
		List<PurchaseOrderDTO> OrderDetailList = purchaseOrderService.orderDetail();
		model.addAttribute("orderList", OrderDetailList);
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
