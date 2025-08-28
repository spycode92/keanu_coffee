package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
		int totalNumberOfWarehouseLocationsToCreate = racks * bays * levels * positions;
		System.out.println(totalNumberOfWarehouseLocationsToCreate);
		
		char[] letters = new char[26];

		for (int i = 0; i < 26; i++) {
		    letters[i] = (char) ('A' + i); //  uppercase letters
		}
		char[] lowerLetters = new char[26];
		
		for (int i = 0; i < 26; i++) {
			lowerLetters[i] = (char) ('a' + i); // lowercase letters
		}
		
//		create a list of locations to be inserted into DB
		List<String> locationList = new ArrayList<String>();
		
		for(int i = 0; i < racks; i++) {
			char rack = letters[i];  // creates a letter for each rack
			for(int j = 0; j < bays; j++) {
				int bay = j;  // creates a number for each bay
				for(int k = 0; k < levels; k++) {
					char levelLetter = lowerLetters[k];  // creates a letter for each level
					for(int l = 0; l < positions; l++) {
						locationList.add(rack + "-" + bay + "-" + levelLetter + l); //creates a position number and then inserts one position's total location values into location list
					}
				}
			}
		}
		
		
		inventoryActionsService.registWarehouse(locationList, width, depth, height);
		
		return "/inventory/updateWarehouse";
	}
	
	
	
	
	
}


















