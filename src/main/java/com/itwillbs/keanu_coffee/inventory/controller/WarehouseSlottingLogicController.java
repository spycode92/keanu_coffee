//package com.itwillbs.keanu_coffee.inventory.controller;
//
//import java.util.ArrayList;
//import java.util.Comparator;
//import java.util.List;
//
//import javax.servlet.http.HttpSession;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.scheduling.annotation.Scheduled;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.GetMapping;
//
//import com.itwillbs.keanu_coffee.common.service.PurchaseOrderService;
//import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
//import com.itwillbs.keanu_coffee.inventory.dto.AvailableWarehouseSpaceDTO;
//import com.itwillbs.keanu_coffee.inventory.service.WarehouseSlottingLogicService;
//
//@Controller
//public class WarehouseSlottingLogicController {
//	private WarehouseSlottingLogicService wslService;
//	
//	public WarehouseSlottingLogicController(WarehouseSlottingLogicService wslService) {
//		this.wslService = wslService;
//	}
//	@Autowired
//	PurchaseOrderService purchaseOrderService;
//
//// pallet zone default sizes (does not include unusable space):
//// rack size - depth: 110cm height 600cm width: 1100 -   One rack is 1 pallet deep many pallets wide and 4 pallets tall
//// bay size - depth: 110cm height 600cm width: 110 -   One bay is 1 pallet deep 1 pallets wide and 4 pallets tall
//// level size - depth: 110cm height 150cm width: 110 -   One level is 1 pallet deep 1 pallet wide and 1 pallet tall
//	
//	//picking zone default sizes
//// rack size - depth: 110cm height 150 width: 110 * 15 -   One rack is 1 pallet deep many pallets wide and 1 pallet tall
//// bay size - depth: 110 cm height 150 width: 110 -   One bay is 1 pallet deep 1 pallets wide and 1 pallet1 tall
//// level size - depth: 110cm height 150cm width: 110 -   One level is 1 pallet deep 1 pallet wide and 1 pallet tall
//	
//
////	
//	
////	lastMonthInventoryTurnoverRate
////		- product order table item quantity ordered each month
////	    - Categorize inventory based on sales volume (velocity) using ABC analysis 
//	
////(A = high velocity, B = medium velocity, C = low velocity).
//	
//	int[] highVelocityProducts = {101, 113, 114, 115, 116, 103, 127, 128, 129, 130, 131, 132, 119, 120, 121, 122};      // Cups & lids Milk & syrup Coffee 
//
//
//	int[] mediumVelocityProducts = {
//	  104, 117, 118,                    // Tea & matcha
//	  106, 107, 108, 109, 110,          // Accessories
//	  133, 134, 135, 136, 137           // Sleeves, straws, napkins, carriers
//	};
//
//	int[] lowVelocityProducts = {
//	  102,                              // Sugar sticks
//	  123, 124, 125, 126,               // Office supplies
//	  138, 139, 140, 141, 142, 143      // Cleaning & safety
//	  
//	};
//	
//	
//	
////	List<AvailableWarehouseSpaceDTO> openLocationsInPickingZone = wslService.getOpenLocationFromPickingZone();  //this is causing problems
//	
//	
////	@GetMapping("locationForItemsInPurchaseOrder")
//	@Scheduled(cron = "0 * * * * *") // scheduled?
//	public void locationForItemsInPurchaseOrder(HttpSession session) {
//		List<InboundDetailDTO> getInboundProductThatNeedLocation = wslService.getInboundProductThatNeedLocation();
//
//	
//	//     percent of warehouse volume currently being used
////	  double pctWarehouseUsed = purchaseOrderService.getPercentOfWarehouseUsed();
////	  
////	  System.out.println("percent of warehouse used: " + pctWarehouseUsed);
//	  
//		
//		
//	//  Date[] lastMonth = DateUtils.getPreviousMonthRange();
//	//	List<ProductOrderDTO> productOrderList = wslService.getSalesStats(lastMonth[0], lastMonth[1]);
//	//	
//	//	warehouseSize
//	//	
//	//	pickingZoneShelvesCloseToPackingZone = bays asc 
//	//	
//	//	palletZoneShelvesCloseToPickingZone = racks  asc from e
//	  
//	  
//	  //get list of warehouse locations that have available space (at least 10% available)
//		List<AvailableWarehouseSpaceDTO> openLocationsInPalletZone = wslService.getOpenLocationFromPalletZone();
//		
//		
//		
//// logic for determining the best location for each item
//		
//		//logic for picking zone
//		
//	
//		//how to call
////		AvailableWarehouseSpaceDTO slot = findPriorityLocation(pickingZoneLocations, "SKU123", "A");
////		if (slot != null) {
////		    System.out.println("Assigned to: " + slot.getLocationName());
////		} else {
////		    System.out.println("No suitable location found.");
////		}
//		
//		
//		
//	  
//	  
//	  
//	//  4호(340 x 250 x 210) = 17,850cm, 5호(410 x 310 x 280) = 24,108cm, 6호(480 x 370 x 340) = 60,384cm
//	  Slot pallet = new Slot();
//	  Box box4 = new Box("4호", 34, 25, 21);
//	  Box box5 = new Box("5호", 41, 31, 28);
//	  Box box6 = new Box("6호", 48, 37, 34);
//	
//	  boolean result = addBoxToSlot(pallet, box4); // Adds first box
//	  boolean result2 = addBoxToSlot(pallet, box5); // Tries to add second box
//	  boolean result3 = addBoxToSlot(pallet, box6); // Tries to add second box
//	  
//	}  // end of logic method
//	public AvailableWarehouseSpaceDTO findPriorityLocation(List<AvailableWarehouseSpaceDTO> locations, int productIdx, String abcClass) {
//		// 1. Same product, same location
//		for (AvailableWarehouseSpaceDTO loc : locations) {
//			if (productIdx == loc.getProductIdx1() || productIdx == loc.getProductIdx2() || productIdx == loc.getProductIdx3()) {
//				return loc;
//			}
//		}
//		
//		// 2. Adjacent location in same rack
//		for (AvailableWarehouseSpaceDTO loc : locations) {
//			if (productIdx == loc.getProductIdx1() || productIdx == loc.getProductIdx2() || productIdx == loc.getProductIdx3()) {
//				AvailableWarehouseSpaceDTO adjacent = findAdjacentLocation(loc, locations);
//				if (adjacent != null) return adjacent;
//			}
//		}
//		
//		// 3. ABC classification fallback
//		return findBestABCSlot(locations, abcClass);
//	};
//	
//	
//	private AvailableWarehouseSpaceDTO findAdjacentLocation(AvailableWarehouseSpaceDTO current, List<AvailableWarehouseSpaceDTO> locations) {
//		int[] offsets = {-1, 1}; // check previous and next bay
//		for (int offset : offsets) {
//			int targetBay = current.getBay() + offset;
//			if (targetBay >= 1 && targetBay <= 15) {
//				String targetName = current.getRack() + "-" + String.format("%02d", targetBay) + "-A1";
//				for (AvailableWarehouseSpaceDTO loc : locations) {
//					if (loc.getLocationName().equals(targetName)) {  
//						return loc;
//					}
//				}
//			}
//		}
//		return null;
//	}
//	
//	private AvailableWarehouseSpaceDTO findBestABCSlot(List<AvailableWarehouseSpaceDTO> locations, String abcClass) {
//		// Sort by bay ascending (lower bay = higher priority)
//		return locations.stream()
//				.sorted(Comparator.comparingInt(loc -> loc.getBay()))
//				.findFirst()
//				.orElse(null);
//	}
//	
//	
//	
//	
//	  public boolean canFitBox(Slot slot, Box newBox) {
//		    for (int x = 0; x <= slot.length - newBox.length; x++) {
//		        for (int y = 0; y <= slot.width - newBox.width; y++) {
//		            for (int z = 0; z <= slot.height - newBox.height; z++) {
//		                if (isSpaceFree(slot, newBox, x, y, z)) {
//		                    return true;
//		                }
//		            }
//		        }
//		    }
//		    return false;
//		}
//	
//		private boolean isSpaceFree(Slot slot, Box box, int x, int y, int z) {
//		    for (BoxPlacement placed : slot.placedBoxes) {
//		        if (boxesOverlap(placed, box, x, y, z)) {
//		            return false;
//		        }
//		    }
//		    return true;
//		}
//	
//		private boolean boxesOverlap(BoxPlacement placed, Box box, int x, int y, int z) {
//		    return !(x + box.length <= placed.x ||
//		             x >= placed.x + placed.box.length ||
//		             y + box.width <= placed.y ||
//		             y >= placed.y + placed.box.width ||
//		             z + box.height <= placed.z ||
//		             z >= placed.z + placed.box.height);
//		}
//		
//		
//		public boolean addBoxToSlot(Slot slot, Box box) {
//		    for (int x = 0; x <= slot.length - box.length; x++) {
//		        for (int y = 0; y <= slot.width - box.width; y++) {
//		            for (int z = 0; z <= slot.height - box.height; z++) {
//		                if (isSpaceFree(slot, box, x, y, z)) {
//		                    slot.placedBoxes.add(new BoxPlacement(box, x, y, z));
//		                    return true;
//		                }
//		            }
//		        }
//		    }
//		    return false;
//		}
//  
//	}
//	
//
//class Slot {
//    int length = 110;
//    int width = 110;
//    int height = 150;
//
//    List<BoxPlacement> placedBoxes = new ArrayList<>();
//}
//class Box {
//    String type;
//    int length;
//    int width;
//    int height;
//
//    public Box(String type, int length, int width, int height) {
//        this.type = type;
//        this.length = length;
//        this.width = width;
//        this.height = height;
//    }
//}
//
//class BoxPlacement {
//    public BoxPlacement(Box box, int x, int y, int z) {
//    	this.box = box;
//    	this.x = x;
//    	this.y = y;
//    	this.z = z;
//	}
//	Box box;
//    int x, y, z; // position on the pallet
//}
