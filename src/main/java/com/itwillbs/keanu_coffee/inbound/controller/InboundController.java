package com.itwillbs.keanu_coffee.inbound.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;
import com.itwillbs.keanu_coffee.inbound.service.InboundService;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	private final InboundService inboundService;
	private static final Logger log = LoggerFactory.getLogger(InboundController.class);
	
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
									Model model) {
		
		// 1) 기본정보 보드 조회
	    InboundDetailDTO inboundDetailData = inboundService.getInboundDetailData(ibwaitIdx);
	    model.addAttribute("inboundDetailData", inboundDetailData);
		
	    // 2) 상품 상세 정보 조회
	    List<InboundProductDetailDTO> ibProductDetail = inboundService.getInboundProductDetail(orderNumber);
	    model.addAttribute("ibProductDetail", ibProductDetail);
	    
		return "/inbound/inboundDetail";
	}
	
	@PostMapping(path="/updateLocation", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> updateLocation(@RequestBody UpdateLocationReq req){
		
		// 로그로 값 확인
		log.info("[updateLocation] ibwaitIdx={}, inboundLocation={}", req.getIbwaitIdx(), req.getInboundLocation());

		// 서비스 작동
		inboundService.updateLocation(req.getIbwaitIdx(), req.getInboundLocation());
		
		return Map.of(
			"ok", true, "ibwaitIdx", req.getIbwaitIdx(), "inboundLocation", req.getInboundLocation()
		);
	}
	
	@GetMapping(path="/managerCandidates", produces="application/json")
	@ResponseBody
	public List<EmployeeInfoDTO> managerCandidates(){
		return inboundService.findManagers();
	}

	@PostMapping(path="/updateManager", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> updateManager(@RequestBody UpdateManagerReq req){
		 inboundService.updateManager(req.getIbwaitIdx(), req.getManagerName());
		return Map.of(
			"ok", true, "ibwaitIdx", 
			req.getIbwaitIdx(), "managerIdx", req.getManagerIdx(), "managerName", req.getManagerName()
		);
	}
	
	// ====================================================================================================================================
	// 입고검수
	@GetMapping("/inboundInspection")
	public String showInboundInspection(@RequestParam(name="orderNumber", required=false) String orderNumber, 
										@RequestParam(name="ibwaitIdx", required=false) Integer ibwaitIdx,
										Model model) {
		
		// 1) 기본정보 보드 조회
	    InboundDetailDTO inboundDetailData = inboundService.getInboundDetailData(ibwaitIdx);
	    model.addAttribute("inboundDetailData", inboundDetailData);
		
	    // 2) 상품 상세 정보 조회
	    List<InboundProductDetailDTO> ibProductDetail = inboundService.getInboundProductDetail(orderNumber);
	    model.addAttribute("ibProductDetail", ibProductDetail);
		
		return "/inbound/inboundInspection";
	}
	
	// 검수완료
	@PostMapping(path="/inspectionComplete", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> inspectionComplete(@RequestBody ReceiptProductDTO dto) {
		boolean exists = inboundService.findDataExists(dto.getIbwaitIdx(), dto.getProductIdx(), dto.getLotNumber());
		inboundService.inspectionCompleteUpdate(dto, exists);

		return Map.of("ok", true);
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
	// ====================================================================================================================DATA============
	@Data
	public static class EmployeeOption {
		private Long employeeIdx;
		private String employeeName;
	}

	@Data
	public static class UpdateManagerReq {
		private Long ibwaitIdx;
		private Long managerIdx;
		private String managerName; 
	}
	
	@Data 
	public static class UpdateLocationReq { 
		private Long ibwaitIdx; 
		private String inboundLocation; 
	}
}
