package com.itwillbs.keanu_coffee.outbound.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundInspectionDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundInspectionItemDTO;
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
	public String showOutboundManagement(
			@RequestParam(required = false) String simpleKeyword, @RequestParam(required = false) String outboundNumber,
			@RequestParam(required = false) String franchiseKeyword, @RequestParam(required = false) String status,
			@RequestParam(required = false) String outRequestDate, @RequestParam(required = false) String outExpectDate,
			@RequestParam(required = false) String outRangeStart, @RequestParam(required = false) String outRangeEnd,
			@RequestParam(defaultValue = "1") int pageNum, Model model) {
		
		int pageSize = 10;   // 한 페이지에 보여줄 건수
		int startRow = (pageNum - 1) * pageSize;
		
		// 검색
		Map<String, Object> searchParams = new HashMap<>();
		searchParams.put("simpleKeyword", simpleKeyword);
		searchParams.put("outboundNumber", outboundNumber);
		searchParams.put("franchiseKeyword", franchiseKeyword);
		searchParams.put("status", status);
		searchParams.put("outRequestDate", outRequestDate);
		searchParams.put("outExpectDate", outExpectDate);
		searchParams.put("outRangeStart", outRangeStart);
		searchParams.put("outRangeEnd", outRangeEnd);
		searchParams.put("startRow", startRow);
		searchParams.put("pageSize", pageSize);
		
		// 전체 건수 조회
		int totalCount = outboundService.getOutboundTotalCount(searchParams);
		
		// 리스트 조회
		List<OutboundManagementDTO> obManagement = outboundService.getAllObManagementList(searchParams, startRow, pageSize);
		
		// 총 페이지 수
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);
		
		obManagement.forEach(o -> {
		    System.out.println("출고번호=" + o.getObwaitNumber()
		        + ", 출고일자=" + o.getDepartureDate()
		        + ", 출고위치=" + o.getOutboundLocation()
		        + ", 프랜차이즈=" + o.getFranchiseName());
		});
		
		// 출고 리스트 조회
		model.addAttribute("obManagement", obManagement);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("totalCount", totalCount);
		
	    return "/outbound/outboundManagement";
	}
	
	// 출고상세페이지
	@GetMapping("/outboundDetail")
	public String showOutboundDetail(@RequestParam("obwaitNumber") String obwaitNumber,
	        						@RequestParam("outboundOrderIdx") Long outboundOrderIdx,
	        						Model model) {
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		EmployeeDetail emp = (EmployeeDetail) auth.getPrincipal();
		model.addAttribute("currentUserName", emp.getEmpName());
		
	    // 출고 기본정보 조회
	    OutboundManagementDTO obDetail = outboundService.getOutboundDetail(obwaitNumber, outboundOrderIdx);
	    model.addAttribute("obDetail", obDetail);
	    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + obDetail);	    
	    
	    
	    // 출고 품목 리스트 조회
	    List<OutboundProductDetailDTO> obProductList = outboundService.getOutboundProductDetail(outboundOrderIdx);
	    model.addAttribute("obProductList", obProductList);

	    return "/outbound/outboundDetail";
	}
	
	// 매니저검색
	@GetMapping(path="/managerCandidates", produces="application/json")
	@ResponseBody
	public List<EmployeeInfoDTO> managerCandidates(){
		return outboundService.findManagers();
	}
	
	@PostMapping(path="/updateManagers", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> updateManagers(@RequestBody Map<String, Object> payload) {
	    List<Integer> obwaitIdxList = (List<Integer>) payload.get("obwaitIdxList");
	    String managerName = payload.get("managerName").toString();

	    if(obwaitIdxList == null || obwaitIdxList.isEmpty()){
	        return Map.of("ok", false, "message", "선택된 출고건이 없습니다.");
	    }

	    outboundService.updateManagers(obwaitIdxList, managerName);

	    return Map.of(
	        "ok", true,
	        "count", obwaitIdxList.size(),
	        "managerName", managerName
	    );
	}
	
	// 출고요청
	@GetMapping("/outboundRegister")
	public String showOutboundRegister() {
		return "/outbound/outboundRegister";
	}
	
	// 출고검수
	@GetMapping("/outboundInspection")
	public String showOutboundInspection(
	        @RequestParam("obwaitIdx") Integer obwaitIdx,
	        @RequestParam("orderNumber") String orderNumber,
	        @RequestParam("outboundOrderIdx") Integer outboundOrderIdx,
	        Model model) {

	    // 1) 출고 기본정보 조회
	    OutboundInspectionDTO obDetail = outboundService.getOutboundDetailByIdx(obwaitIdx, orderNumber);
	    model.addAttribute("obDetail", obDetail);
	    

	    
	    // 품목 리스트
	    List<OutboundInspectionItemDTO> obProductList = outboundService.getOutboundInspectionItems(outboundOrderIdx);
	    model.addAttribute("obProductList", obProductList);

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
	
	// test
	@GetMapping("/qrTest")
    public String qrTestPage() {
        return "/outbound/qrTest";
    }
}
