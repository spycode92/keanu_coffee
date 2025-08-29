package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryMapper;

@Service
public class InventoryService {
	private final InventoryMapper inventoryMapper;
	
	

	public InventoryService(InventoryMapper inventoryMapper) {
		super();
		this.inventoryMapper = inventoryMapper;
	}



	public int[] getWarehouseInfo() {
		
		return inventoryMapper.selectWarehouseInfo();
	}



//	public List<InventoryDTO> getInventoryThatNeedsToMoveFromInbound() {
//		// TODO Auto-generated method stub
//		return inventoryMapper.selectInventoryThatNeedsToMoveFromInbound();
//	}
//
//
//
//	public List<InventoryDTO> getInventoryThatNeedsToMoveToOutbound() {
//		// TODO Auto-generated method stub
//		return inventoryMapper.selectInventoryThatNeedsToMoveToOutbound();
//	}

}
