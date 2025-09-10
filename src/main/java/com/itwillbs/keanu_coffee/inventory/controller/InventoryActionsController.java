package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.inventory.dto.CreateWarehouseDTO;
import com.itwillbs.keanu_coffee.inventory.service.InventoryActionsService;

@Controller
@RequestMapping("inventoryAction")
public class InventoryActionsController {
	private final InventoryActionsService inventoryActionsService;

	public InventoryActionsController(InventoryActionsService inventoryActionsService) {
		this.inventoryActionsService = inventoryActionsService;
	}
	
	@PostMapping("/create-warehouse")
	public String createWarehouse(
			@RequestParam("racks") int racks, 
			@RequestParam("bays") int bays,
			@RequestParam("levels") int levels,
			@RequestParam("positions") int positions,
			@RequestParam("width") int width,
			@RequestParam("depth") int depth,
			@RequestParam("height") int height,
			Model model
			) {
		
		if (racks > 26 || levels > 26) {
		    throw new IllegalArgumentException("Max 26 racks and 26 levels supported.");
		}
		System.out.println("RACKS : " + racks);
		System.out.println("bays : " + bays);
		System.out.println("levels : " + levels);
		System.out.println("positions : " + positions);
		System.out.println("width : " + width);
		System.out.println("depth : " + depth);
		System.out.println("height : " + height);
		
		List<CreateWarehouseDTO> locationList = new ArrayList<CreateWarehouseDTO>();
		
		
		
		int totalNumberOfWarehouseLocationsToCreate = racks * bays * levels * positions;
//		System.out.println("number of locations to create : " + totalNumberOfWarehouseLocationsToCreate);
		
		char[] letters = new char[26];

		for (int i = 0; i < 26; i++) {
		    letters[i] = (char) ('A' + i); //  uppercase letters
		}
		char[] lowerLetters = new char[26];
		
		for (int i = 0; i < 26; i++) {
			lowerLetters[i] = (char)('a' + i); // lowercase letters
		}
		
//		create a list of locations to be inserted into DB
		System.out.println("locationList : " + locationList);
		
		for(int i = 0; i < racks; i++) {
			char rack = letters[i];  // creates a letter for each rack
			for(int j = 1; j < bays; j++) {
				int bay = j;  // creates a number for each bay
				for(int k = 0; k < levels; k++) {
					char levelLetter = lowerLetters[k];  // creates a letter for each level
					for(int l = 1; l < positions; l++) {
						String locationName = rack + "-" + bay + "-" + (levelLetter + String.valueOf(l)); 
						locationList.add(new CreateWarehouseDTO(locationName, rack, bay, (levelLetter + String.valueOf(l)), width, height, depth));
				
//						CreateWarehouseDTO createWarehouseDTO = new CreateWarehouseDTO();
//						createWarehouseDTO.setRack(rack);
//						createWarehouseDTO.setBay(bay);
//						createWarehouseDTO.setLevelPostion(levelLetter + String.valueOf(l)); //creates a position number and then adds it to level letter to create levelPosition
//						createWarehouseDTO.setWidth(width);
//						createWarehouseDTO.setHeight(height);
//						createWarehouseDTO.setDepth(depth);
//						locationList.add(createWarehouseDTO);
						
//						CreateWarehouseDTO createWarehouseDTO = CreateWarehouseDTO.builder()
//								.rack(rack)
//								.bay(bay)
//								.levelPostion(null)
//								.build();
					}
				}
			}
		}
		for (int i = 0; i < locationList.size(); i++) {
			
			inventoryActionsService.registWarehouse(locationList.get(i));
		}
		
		
		
		return "inventory/update_warehouse";
	}
	
	
	//move inventory
	// when all inventory from one location is moved the inventory row needs to be deleted
	// I need to make a default location for the inbound area
	
	
	
	
	
}


















