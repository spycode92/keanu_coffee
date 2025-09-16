package com.itwillbs.keanu_coffee.inventory.controller;




import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.inventory.service.InventoryMoveService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/inventory/move")
@RequiredArgsConstructor
public class InventoryMoveController {
	
	private final InventoryMoveService inventoryMoveService;
	
	
	

}
