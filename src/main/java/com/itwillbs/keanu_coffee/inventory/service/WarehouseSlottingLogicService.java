package com.itwillbs.keanu_coffee.inventory.service;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inventory.dto.AvailableWarehouseSpaceDTO;
//import com.itwillbs.keanu_coffee.inventory.controller.ProductOrderDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.WarehouseSlottingLogicMapper;

@Service
public class WarehouseSlottingLogicService {
	private final WarehouseSlottingLogicMapper wslMapper;
	
	public WarehouseSlottingLogicService(WarehouseSlottingLogicMapper wslMapper) {
		this.wslMapper = wslMapper;
	}

	public List<AvailableWarehouseSpaceDTO> getOpenLocationFromPickingZone() {
		return wslMapper.selectOpenLocationFromPickingZone();
	}

	public List<AvailableWarehouseSpaceDTO> getOpenLocationFromPalletZone() {
		// TODO Auto-generated method stub
		return wslMapper.selectOpenLocationFromPalletZone();
	}

	public List<InboundDetailDTO> getInboundProductThatNeedLocation() {
		// TODO Auto-generated method stub
		return wslMapper.selectInboundProductThatNeedLocation();
	}
	
	

//	public List<ProductOrderDTO> getSalesStats(Date startOfMonth, Date endOfMonth) {
//		return wslMapper.selectSalesStats(startOfMonth, endOfMonth);
//	}
	
	
}
