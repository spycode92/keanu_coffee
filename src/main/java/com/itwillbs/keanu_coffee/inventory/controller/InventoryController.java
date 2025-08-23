package com.itwillbs.keanu_coffee.inventory.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import com.itwillbs.keanu_coffee.inventory.service.InventoryService;

@Controller
@RequestMapping("/inventory")
public class InventoryController {
//	private final InventoryService inventoryService;
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
   
	@GetMapping("/productHistory")
	public String productHistory() {
		
		return "inventory/inventory_location_history";
	}
	@GetMapping("/updateInventory")
	public String updateInventory() {
		
		return "inventory/update_inventory";
	}
	@GetMapping("/updateWarehouse")
	public String updateWarehouse() {
		
		return "inventory/update_warehouse";
	}
	@GetMapping("/moveInventory")
	public String moveInventory() {
		
		return "inventory/move_inventory";
	}
	@GetMapping("/updatedInventory")
	public String updatedInventory() {
		
		return "inventory/updated_inventory_table";
	}
	@GetMapping("/inventoryToMove")
	public String inventoryToMove() {
		
		return "inventory/inventory_to_move";
	}
	@GetMapping("/test")
	public String test() {
		
		return "test";
	}
	@GetMapping("/test2")
	public String test2() {
		
		return "test2";
	}



}
