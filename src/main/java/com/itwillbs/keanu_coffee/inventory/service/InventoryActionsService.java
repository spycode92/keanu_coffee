package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.inventory.dto.CreateWarehouseDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryActionsMapper;

@Service
public class InventoryActionsService {
	private final InventoryActionsMapper inventoryActionsMapper;
	
	
	
	public InventoryActionsService(InventoryActionsMapper inventoryActionsMapper) {
		this.inventoryActionsMapper = inventoryActionsMapper;
	}

	@Transactional
	public String registWarehouse(List<CreateWarehouseDTO> locationList) {
		
		return inventoryActionsMapper.insertWarehouse(locationList);
	}
	
}
