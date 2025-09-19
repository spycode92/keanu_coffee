package com.itwillbs.keanu_coffee.inventory.controller;




import java.util.ArrayList;
import java.util.List;

import org.springframework.security.core.Authentication;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;
import com.itwillbs.keanu_coffee.inventory.service.InventoryService;

@Controller
@RequestMapping("/inventory")
public class InventoryController {
	private final InventoryService inventoryService;
	
	
	public InventoryController(InventoryService inventoryService) {
		this.inventoryService = inventoryService;
	}

	// 재고현황 페이지 - 대시보드
	@GetMapping("/main")
	public String inventoryDashboard() {
		return "inventory/inventoryDashboard";
	}
	
//	// 재고 조회 / 검수 
//	@GetMapping("/stockCheck")
//	public String stockCheckForm() {
//		return "inventory/stockCheck";
//	}
   
	@GetMapping("/productHistory")
	public String productHistory() {
		
		return "inventory/inventory_location_history";
	}
	
	// 재고 업데이트
	@GetMapping("/updateInventory")
	public String updateInventory() {
		
		return "inventory/update_inventory";
	}
	
	@GetMapping("/updateWarehouse")
	public String updateWarehouse(Model model) {
		WarehouseInfoDTO warehouseInfo = inventoryService.getWarehouseInfo();
		model.addAttribute("warehouseInfo", warehouseInfo);

		
		return "inventory/update_warehouse";
	}
	
	@GetMapping("/moveInventory")
	public String moveInventory(Authentication authentication, Model model) {
		
		return "inventory/move_inventory";
	}
	
	@GetMapping("/moveInventory/cart")
	public String moveInventoryCart(Authentication authentication, Model model) {
		
		return "redirect:/inventory/move/cart";
	}
	
	@GetMapping("/updatedInventory")
	public String updatedInventory() {
		
		return "inventory/updated_inventory_table";
	}
	
	@GetMapping("/inventoryToMove")
	public String inventoryToMove() {
		
		return "inventory/inventory_to_move";
	}

	@GetMapping("/qrScanner")
	public String qrScanner(@RequestParam(required = false) String param) {
	
		return "inventory/QR-scanner";
	}



}
