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
		
	// get any inventory items currently in the employees virtual location so that the employee does not
	// have to search to find what the inventoryIdx of the item the are placing is
		EmployeeDetail employeeDetail = (EmployeeDetail)authentication.getPrincipal();
//		int[] inventoryItemsInEmployeesVirtualLocation = inventoryService.getInventoryItemsInEmployeesVirtualLocation(principal.getEmpIdx());
//		System.out.println("authentication" + authentication);
		System.out.println("employee idx : " + employeeDetail.getEmpIdx());
		List<InventoryDTO> result = inventoryService.getInventoryItemsInEmployeesVirtualLocation(employeeDetail.getEmpIdx());
		List<InventoryDTO> inventoryItemsInEmployeesVirtualLocation = result == null ? new ArrayList<InventoryDTO>() : result;
		
		model.addAttribute("employeeInventory", inventoryItemsInEmployeesVirtualLocation);
		
		
		
		
		return "inventory/move_inventory";
	}
	
	@GetMapping("/updatedInventory")
	public String updatedInventory() {
		
		return "inventory/updated_inventory_table";
	}
	
	@GetMapping("/inventoryToMove")
	public String inventoryToMove(Model model) {
		// when page loads it fills up with inventory items that need to be moved from pallet zone to picking zone
//		List<InventoryDTO> inboundDTO = inventoryService.getInventoryThatNeedsToMoveFromInbound();
//		List<InventoryDTO> outboundDTO = inventoryService.getInventoryThatNeedsToMoveToOutbound();
//		
//		model.addAttribute("inventoryToMove", inboundDTO);
//		model.addAttribute("inventoryToMove", outboundDTO);
		
		
		return "inventory/inventory_to_move";
	}

	@GetMapping("/qrScanner")
	public String qrScanner(@RequestParam(required = false) String param) {
	
		return "inventory/QR-scanner";
	}



}
