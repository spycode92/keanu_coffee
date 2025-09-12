package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;
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
			@RequestParam("locationType") int locationType,
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
		System.out.println("location type : " + locationType);		
		List<WarehouseLocationDTO> locationList = new ArrayList<>();
		
		
		
		int totalNumberOfWarehouseLocationsToCreate = racks * bays * levels * positions;
		System.out.println("number of locations to create : " + totalNumberOfWarehouseLocationsToCreate);
		
		String lastCurrentLocation = inventoryActionsService.getLastCurrentLocation();
		System.out.println("lastcurrent location ; " + lastCurrentLocation);
//		char lastRack = lastCurrentLocation.substring(0, 1).charAt(0);
//		System.out.println(lastRack);
//		int lastBay = Integer.parseInt(lastCurrentLocation.substring(2, 4));
//		System.out.println(lastBay);

		char lastRack = 'A'; // default starting rack

		if (lastCurrentLocation != null && lastCurrentLocation.length() >= 4) {
		    try {
		        lastRack = lastCurrentLocation.substring(0, 1).charAt(0);
		    } catch (Exception e) {
		        System.err.println("Invalid lastCurrentLocation format: " + lastCurrentLocation);
		        // fallback to default values
		        lastRack = 'A';
		    }
		} else {
		    System.out.println("No previous location found. Starting from default.");
		}
		
		System.out.println("last rack : " + lastRack);
		
		
		String[] letters = new String[26];

		for (int i = 0; i < 26; i++) {
			letters[i] = String.valueOf((char) ('A' + i));

//		    letters[i] = (char)('A' + i); //  uppercase letters
		}
		char[] lowerLetters = new char[26];
		
		for (int i = 0; i < 26; i++) {
			lowerLetters[i] = (char)('a' + i); // lowercase letters
		}
		
		
//		create a list of locations to be inserted into DB
		System.out.println("locationList : " + locationList);
		
//		for(int i = 0; i < racks; i++) {
//			char rack = letters[i];  // creates a letter for each rack
//			for(int j = 1; j < bays; j++) {
//				
//				int bay = j;  // creates a number for each bay
//				String paddedBay = String.format("%02d", bay);  // pad bay with leading zero
//
//				for(int k = 0; k < levels; k++) {
//					char levelLetter = lowerLetters[k];  // creates a letter for each level
//					for(int l = 1; l < positions; l++) {
//						String locationName = rack + "-" + paddedBay + "-" + (levelLetter + String.valueOf(l)); 
//						locationList.add(new CreateWarehouseDTO(locationName, rack, bay, (levelLetter + String.valueOf(l)), width, height, depth));
		int startRackIndex = (lastRack - 'A') 
//				;
				+ 1; // Calculate the starting index based on lastRack
		System.out.println("start rack index " + startRackIndex);
		for (int i = startRackIndex; i < 
				startRackIndex + 
				racks; i++) {  //this might need to be adjusted if there is no racks yet
		    if (i >= 26) break;
			String rack = letters[i];

//		    int startBay = (i == startRackIndex) ? lastBay + 1 : 1;

		    for (int j = 1; j <= bays; j++) { // include bay 1
		        int bay = j;
		        String paddedBay = String.format("%02d", bay);

		        for (int k = 0; k < levels; k++) {
		            char levelLetter = lowerLetters[k];

		            for (int l = 1; l <= positions; l++) { // include position 1
		                String levelPosition = levelLetter + String.valueOf(l);
		                String locationName = rack + "-" + paddedBay + "-" + levelPosition;
		                System.out.println(locationName + "-" + rack + "-" + bay + "-" +levelPosition + "-" + width + "-" + height + "-" + depth + "-" + locationType);

		                locationList.add(new WarehouseLocationDTO(
		                    locationName, rack, bay, levelPosition, width, height, depth, locationType
		                ));
		                System.out.println("Adding location: " + locationName);
		            }
		        }
		    }
		}
				
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

		System.out.println("locationList.getsize" + locationList.size());
		for (int i = 0; i < locationList.size(); i++) {
			System.out.println("locationList.get(i)" + locationList.get(i));
			inventoryActionsService.registWarehouse(locationList.get(i));
		}
		
		
		
		return "inventory/update_warehouse";
	}
	
	
	//move inventory
	// when all inventory from one location is moved the inventory row needs to be deleted
	// I need to make a default location for the inbound area
	@PostMapping("/updateWarehouse")
	public String updateWarehouse( @RequestParam("employee_id") int employeeId, 
			@RequestParam("inventoryId") int inventoryId,
			@RequestParam("qtyMoving") int qtyMoving,
			@RequestParam("destinationType") int destinationType, 
			@RequestParam("destinationName") String destinationName, 
			@RequestParam("moveType") String moveType) {
		
		InventoryDTO inventoryDTO = inventoryActionsService.getquantity(inventoryId);
		
		if(moveType == "pickUp") {
			
			if(qtyMoving == inventoryDTO.getQuantity()) {
				inventoryActionsService.removeRowInInventory(inventoryId);
			} else {
				inventoryActionsService.modifyLocationOfInventory(inventoryId, qtyMoving, employeeId);
				inventoryActionsService.modifyQuantitydecrease(inventoryId, inventoryDTO.getQuantity() - qtyMoving);
			}
			
			//need to finish this
		} else {
			
			
		}
		
		
		
		return "inventoryAction/updateWarehouse";
	}
	
	
	
	
	
}


















