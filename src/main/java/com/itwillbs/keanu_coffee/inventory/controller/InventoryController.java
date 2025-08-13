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
  
  
	@GetMapping("/productHistory")
	public String productHistory() {
		
		return "warehouse&inventory_management/inventory_location_history";
	}
	@GetMapping("/updateInventory")
	public String updateInventory() {
		
		return "warehouse&inventory_management/update_inventory";
	}
	@GetMapping("/updateWarehouse")
	public String updateWarehouse() {
		
		return "warehouse&inventory_management/update_warehouse";
	}
	@GetMapping("/moveInventory")
	public String moveInventory() {
		
		return "warehouse&inventory_management/move_inventory";
	}
	@GetMapping("/updatedInventory")
	public String updatedInventory() {
		
		return "warehouse&inventory_management/updated_inventory_table";
	}
	@GetMapping("/inventoryToMove")
	public String inventoryToMove() {
		
		return "warehouse&inventory_management/inventory_to_move";
	}


}
