package com.itwillbs.keanu_coffee.outbound.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.service.OrderService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/order")
public class OrderController {

	private final ObjectMapper objectMapper;
	private final OrderService orderService;

	@GetMapping("/insert")
	public String outboundOrder(Model model) {
		// 지점 리스트 가져오기
		List<FranchiseDTO> franchiseList = orderService.getAllFranchise();
		// 제품 리스트 가져오기
		List<ProductDTO> productList = orderService.getAllProducts();
		
		model.addAttribute("franchiseList", franchiseList);
		model.addAttribute("productList", productList);
		return "/outbound/outboundOrder";
	}

	@PostMapping("/insert")
	public String createOutboundOrder(
			@RequestParam("franchiseIdx") Integer franchiseIdx,
			@RequestParam("urgent") String urgent,
			@RequestParam("totalQuantity") Integer totalQuantity,
			@RequestParam("itemsJson") String itemsJson,
			RedirectAttributes ra
	) {
		try {
			List<OutboundOrderItemDTO> items =
				objectMapper.readValue(itemsJson, new TypeReference<List<OutboundOrderItemDTO>>() {});

			OutboundOrderDTO order = OutboundOrderDTO.builder()
					.franchiseIdx(franchiseIdx)
					.urgent(urgent) // 'Y'/'N'
					.status("대기")
					.requestedDate(LocalDateTime.now())
					.expectOutboundDate(null)
					.createdAt(LocalDateTime.now())
					.updatedAt(LocalDateTime.now())
					.items(items)
					.build();

			orderService.addOutboundOrder(order, totalQuantity);

			ra.addFlashAttribute("msg", "출고 주문이 등록되었습니다.");
			return "redirect:/order/insert";
		} catch (Exception e) {
			ra.addFlashAttribute("error", "등록 중 오류가 발생했습니다.");
			return "redirect:/order/insert";
		}
	}
}
