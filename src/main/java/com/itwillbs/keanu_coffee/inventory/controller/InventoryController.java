package com.itwillbs.keanu_coffee.inventory.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory")
public class InventoryController {
	
	// 재고현황 페이지 - 대시보드
	@GetMapping("")
	public String inventoryDashboard() {
		return "inventory/inventoryDashboard";
	}
	
	// 재고 조회 / 검수 
	@GetMapping("/stockCheck")
	public String stockCheckForm() {
		return "inventory/stockCheck";
	}
}
