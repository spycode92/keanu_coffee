package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Controller;

import com.itwillbs.keanu_coffee.common.utils.DateUtils;
import com.itwillbs.keanu_coffee.inventory.service.WarehouseSlottingLogicService;

@Controller
public class WarehouseSlottingLogicController {
	private final WarehouseSlottingLogicService wslService;
	
	
	public WarehouseSlottingLogicController(WarehouseSlottingLogicService wslService) {
		this.wslService = wslService;
	}

// pallet zone default sizes (does not include unusable space):
// rack size - depth: 120cm height 600cm width: ? -   One rack is 1 pallet deep many pallets wide and 4 pallets tall
// bay size - depth: 120cm height 600cm width: 120 -   One bay is 1 pallet deep 1 pallets wide and 4 pallets tall
// level size - depth: 120cm height 150cm width: 120 -   One level is 1 pallet deep 1 pallet wide and 1 pallet tall
	

//
	
//	lastMonthInventoryTurnoverRate
//		- product order table item quantity ordered each month
//	    - Categorize inventory based on sales volume (velocity) using ABC analysis (A = high velocity, B = medium velocity, C = low velocity).
	Date[] lastMonth = DateUtils.getPreviousMonthRange();
//	List<ProductOrderDTO> productOrderList = wslService.getSalesStats(lastMonth[0], lastMonth[1]);
//	
//	warehouseSize
//	
//	pickingZoneShelvesCloseToPackingZone
//	
//	palletZoneShelvesCloseToPickingZone
	
	
}
