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


//	bay size 40cm deep 150cm tall
	
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
