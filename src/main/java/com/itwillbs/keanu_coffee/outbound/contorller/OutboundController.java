package com.itwillbs.keanu_coffee.outbound.contorller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.service.OutboundService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/outbound")
public class OutboundController {
	
	private final OutboundService outboundService; 
	private final ObjectMapper objectMapper = new ObjectMapper();
	
	// 출고지시(for테스팅)
	@GetMapping("/order")
	public String outboundOrder() {
		return "/outbound/outboundOrder";
	}
	
	@PostMapping("/order")
	@ResponseBody
	public String createOutboundOrder(	@RequestParam("franchiseIdx") Integer franchiseIdx
										,@RequestParam("urgent") String urgent
										,@RequestParam("totalQuantity") Integer totalQuantity
										,@RequestParam("itemsJson") String itemsJson	) {
		try {
			// 1) itemsJson -> List<OutboundOrderItemDTO>
			List<OutboundOrderItemDTO> items =
				objectMapper.readValue(itemsJson, new TypeReference<List<OutboundOrderItemDTO>>() {});

			// 2) 상위 주문 DTO 구성 (status는 초기값 "대기" 권장)
			OutboundOrderDTO order = OutboundOrderDTO.builder()
				.franchiseIdx(franchiseIdx)
				.urgent(urgent) // 'Y'/'N'
				.status("대기")
				.requestedDate(LocalDateTime.now())
				.expectOutboundDate(null) // 필요 시 클라이언트에서 받아 세팅
				.createdAt(LocalDateTime.now())
				.updatedAt(LocalDateTime.now())
				.items(items) // 포함
				.build();

			// 1=성공, 0=실패
			outboundService.addOutboundOrder(order, totalQuantity);
			return "/outbound/outboundOrder";
			
		} catch (Exception e) {
			return "/outbound/outboundOrder";
		}
	}
	
	// 대시보드
	@GetMapping("/main")
	public String showOutboundDashboard() {
		return "/outbound/outboundDashboard";
	}
	
	// 출고조회
	@GetMapping("/outboundManagement")
	public String showOutboundManagement() {
		// 출고 리스트 조회
		
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
