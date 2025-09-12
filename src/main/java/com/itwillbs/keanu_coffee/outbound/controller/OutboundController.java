package com.itwillbs.keanu_coffee.outbound.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundManagementDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundProductDetailDTO;
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
	public String showOutboundDetail(@RequestParam("obwaitNumber") String obwaitNumber,
	        						@RequestParam("outboundOrderIdx") Long outboundOrderIdx,
	        						Model model) {

	    // 출고 기본정보 조회
	    OutboundManagementDTO obDetail = outboundService.getOutboundDetail(obwaitNumber, outboundOrderIdx);
	    model.addAttribute("obDetail", obDetail);

	    // 출고 품목 리스트 조회
	    List<OutboundProductDetailDTO> obProductList = outboundService.getOutboundProductDetail(outboundOrderIdx);
	    model.addAttribute("obProductList", obProductList);

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
	
	// 출고 상태변경(대기->출고준비)
	@PostMapping(path = "/updateStatusReady", consumes = "application/json", produces = "application/json")
	@ResponseBody
	public Map<String, Object> updateStatusReady(@RequestBody Map<String, List<Long>> request) {
		List<Long> orderIdxList = request.get("orderIdxList");

		if (orderIdxList == null || orderIdxList.isEmpty()) {
			return Map.of("ok", false, "message", "선택된 출고건이 없습니다.");
		}

		int updatedCount = outboundService.updateStatusReady(orderIdxList);

		return Map.of("ok", true, "updatedCount", updatedCount);
	}
	
	@PostMapping(path="/updateStatusDispatchWait", consumes="application/json", produces="application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> updateStatusDispatchWait(@RequestBody Map<String, Object> req) {
		String obwaitNumber = (String) req.get("obwaitNumber");
		Object raw = req.get("outboundOrderIdx");
		Long outboundOrderIdx = null;
		if (raw instanceof Number) outboundOrderIdx = ((Number) raw).longValue();
		else if (raw instanceof String && !((String)raw).isBlank()) outboundOrderIdx = Long.parseLong((String)raw);

		if (obwaitNumber == null || outboundOrderIdx == null) {
			return Map.of("ok", false, "message", "필수 파라미터 누락(obwaitNumber, outboundOrderIdx)");
		}

		int updatedCount = outboundService.updateStatusDispatchWait(obwaitNumber, outboundOrderIdx);

		return (updatedCount > 0)
			? Map.of("ok", true, "updatedCount", updatedCount, "nextStatus", "DISPATCH_WAIT", "nextStatusLabel", "배차대기")
			: Map.of("ok", false, "message", "변경할 수 없습니다. 현재 상태가 '출고준비'인지 확인하세요.");
	}
	

}
