package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryActionsMapper;

@Service
public class InventoryActionsService {
	private final InventoryActionsMapper inventoryActionsMapper;
	
	
	
	public InventoryActionsService(InventoryActionsMapper inventoryActionsMapper) {
		this.inventoryActionsMapper = inventoryActionsMapper;
	}

	@PreAuthorize("hasAnyAuthority('INVENTORY_WRITE')")
	@Transactional
	public void registWarehouse(WarehouseLocationDTO warehouseLocationDTO) {
		inventoryActionsMapper.insertWarehouse(warehouseLocationDTO);
	}

	public String getLastCurrentLocation() {
		// TODO Auto-generated method stub
		return inventoryActionsMapper.selectLastCurrentLocation();
	}

	public InventoryDTO getquantity(int inventoryId) {
		// TODO Auto-generated method stub
		return inventoryActionsMapper.selectQuantity(inventoryId);
	}
	
	@PreAuthorize("hasAnyAuthority('INVENTORY_READ', 'INVENTORY_WRITE')")
	@Transactional
	public void removeRowInInventory(int inventoryId) {
		inventoryActionsMapper.deleteRowInInventory(inventoryId);
	}

	public void modifyQuantitydecrease(int inventoryId, int qty) {
		inventoryActionsMapper.updateQuantitydecrease(inventoryId, qty);
	}

	public void modifyLocationOfInventory(int inventoryId, int qtyMoving, int employeeId) {
		
		inventoryActionsMapper.updateLocationOfInventory(inventoryId, qtyMoving, employeeId);
		
	}
	
}
