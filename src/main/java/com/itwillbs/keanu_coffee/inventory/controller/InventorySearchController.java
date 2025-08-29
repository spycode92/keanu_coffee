package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.inventory.service.InventorySearchService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory/search")
public class InventorySearchController {
	private final InventorySearchService inventorySearchService;
	
	// 재고 리스트(입고완료 데이터) 조회
	@GetMapping
	public String getStockCheck(Model model) {
		
        // 현재 DTO 없어서 임시로 List<Map<String,Object>> 형태로 받음
        List<Map<String, Object>> list = inventorySearchService.getReceiptProductList();

        model.addAttribute("inventoryList", list);
		
		return "inventory/stockCheck";
	}
	
	
}
