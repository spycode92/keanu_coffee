package com.itwillbs.keanu_coffee.inbound.controller;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.function.Function;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseWithSupplierDTO;
import com.itwillbs.keanu_coffee.common.service.PurchaseOrderService;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.service.InboundService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	private final PurchaseOrderService purchaseOrderService;
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
	    List<InboundManagementDTO> orderDetailList = inboundService.inboundWaitingInfo();

	    // LocalDateTime → String 포맷 처리
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
	    orderDetailList.forEach(dto -> {
	        if (dto.getArrivalDate() != null) {
	            dto.setArrivalDateStr(dto.getArrivalDate().format(formatter));
	        }
	    });

	    // 모델에 전달
	    model.addAttribute("orderList", orderDetailList);

	    return "/inbound/inboundManagement";
	}

	
	// ====================================================================================================================================
	// 입고상세
	@GetMapping("/inboundDetail")
	public String showInboundDetail(@RequestParam(name="orderNumber", required=false) String orderNumber, 
									@RequestParam(name="orderIdx", required=false) Integer orderIdx,
									Model model, RedirectAttributes ra) {
		
		// 1) 파라미터 유효성 검사 (없으면 목록으로 리다이렉트)
		if (orderNumber == null || orderNumber.trim().isEmpty()) {
			ra.addFlashAttribute("errorMessage", "발주번호가 전달되지 않았습니다.");
			return "redirect:/inbound/management";
		}
		
		// 2) productDTO 조회
		List<ProductDTO> product = inboundService.getOrderDetailByOrderNum(orderNumber);
		model.addAttribute("product", product);
		
		// 3) orderIdx로 조회
		List<PurchaseWithSupplierDTO> orderItems = inboundService.getOrderDetailByOrderIdx(orderIdx);
		model.addAttribute("orderItems", orderItems);
		
		// 4) orderItems 내부의 PurchaseOrderItemDTO 를 펼쳐서 productIdx -> item 맵 생성
	    Map<Integer, PurchaseOrderItemDTO> itemMap = orderItems.stream()
	    	.map(PurchaseWithSupplierDTO::getPurchaseOrder)  
	        .filter(o -> o.getItems() != null)                             // items null 체크
	        .flatMap(o -> o.getItems().stream())                           // PurchaseOrderItemDTO 스트림으로 변환
	        .collect(Collectors.toMap(
	            PurchaseOrderItemDTO::getProductIdx,                       // key = productIdx
	            Function.identity(),                                       // value = PurchaseOrderItemDTO
	            (existing, replacement) -> existing,                       // 충돌 시 기존 유지
	            LinkedHashMap::new                                         // 순서 유지
	        ));
	    model.addAttribute("itemMap", itemMap);
		
	    // 5) 담당자 가능 인원 조회
//	    List<EmployeeInfoDTO> inboundStaffNameList = inboundService.getInboundStaffNameList();
//	    model.addAttribute("staffList", inboundStaffNameList);
	    
	    // 6) 회사명 조회
	    int supplierIdx = orderItems.get(0).getPurchaseOrder().getSupplierIdx();
	    String supplierName = inboundService.getSupplierName(supplierIdx);
	    model.addAttribute("supplierName", supplierName);
	    
	    // 7) 
	    
	    
	    
	    
	    
	    
	    
	    
	    
	    
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
