package com.itwillbs.keanu_coffee.inbound.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.service.InboundService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	private final InboundService inboundService;
	
	// ====================================================================================================================================
	// 대시보드
	@GetMapping("/main")
	public String showInboundDashboard() {
		return "/inbound/inboundDashboard";
	}
	
	// ====================================================================================================================================
	// 입고조회
	@GetMapping("/management")
	public String showInboundManagement(Model model) {
	    // 입고 리스트 조회
	    List<InboundManagementDTO> orderDetailList = inboundService.getAllinboundWaitingInfo();
	    model.addAttribute("orderList", orderDetailList);

	    return "/inbound/inboundManagement";
	}

	
	// ====================================================================================================================================
	// 입고상세
	@GetMapping("/inboundDetail")
	public String showInboundDetail(@RequestParam(name="orderNumber", required=false) String orderNumber, 
									@RequestParam(name="ibwaitIdx", required=false) Integer ibwaitIdx,
									HttpSession session) {
		
		// 1) 기본정보 보드 조회
	    InboundDetailDTO inboundDetailData = inboundService.getInboundDetailData(ibwaitIdx);
	    session.setAttribute("inboundDetailData", inboundDetailData);
		
	    // 2) 상품 상세 정보 조회
	    List<InboundProductDetailDTO> ibProductDetail = inboundService.getInboundProductDetail(orderNumber);
	    session.setAttribute("ibProductDetail", ibProductDetail);
	    
		return "/inbound/inboundDetail";
	}
	
	// ====================================================================================================================================
	// 입고등록
	@GetMapping("/inboundRegister")
	public String showInboundRegister() {
		return "/inbound/inboundRegister";
	}
	
	// ====================================================================================================================================
	// 입고확정
	@GetMapping("/inboundConfirm")
	public String showInboundConfirm() {
		return "/inbound/inboundConfirm";
	}
	
	// ====================================================================================================================================
	// 입고검수
	@GetMapping("/inboundInspection")
	public String showInboundInspection() {
		
		return "/inbound/inboundInspection";
	}
	
}
