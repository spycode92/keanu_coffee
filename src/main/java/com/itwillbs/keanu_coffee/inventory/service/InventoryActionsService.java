package com.itwillbs.keanu_coffee.inventory.service;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.ReceiptProductDTO2;
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

	public void addLocationOfInventory(InventoryDTO inventoryDTO, int qtyMoving, int employeeId) {
//		System.out.println("inventoryDTO : " + inventoryDTO);
//		System.out.println("employeeId : " + employeeId);
		inventoryActionsMapper.insertLocationOfInventory(inventoryDTO, qtyMoving, employeeId);
		
	}

	public void modifyLocationOfInventory2(int inventoryId, int qtyMoving, String destinationName, int locationIdxOfDestinationName) {
		
		inventoryActionsMapper.updateLocationOfInventory2(inventoryId, qtyMoving, destinationName, locationIdxOfDestinationName);
	}

//	public int getlocationIdxOfDestinationName(String destinationName) {
	public InventoryDTO getlocationIdxOfDestinationName(String destinationName) {
		return inventoryActionsMapper.selectlocationIdxOfDestinationName(destinationName);
	}

	public void addLocationOfInventory2(InventoryDTO inventoryDTO, int qtyMoving, String destinationName,
			int locationIdxOfDestinationName) {
		inventoryActionsMapper.insertLocationOfInventory2(inventoryDTO, qtyMoving, destinationName, locationIdxOfDestinationName);
	}

	public ReceiptProductDTO2 getReceiptProduct(int receiptID) {
		// TODO Auto-generated method stub
		return inventoryActionsMapper.selectReceiptProduct(receiptID);
	}

	public void addLocationOfInventory3(int receiptProductIdx, int locationIdxOfDestinationName, String destinationName,
			int productIdx, int qtyMoving, String lotNumber, Date manufactureDate, Date expirationDate) {
		
		inventoryActionsMapper.insertLocationOfInventory3(receiptProductIdx, locationIdxOfDestinationName, destinationName,
				productIdx, qtyMoving, lotNumber, manufactureDate, expirationDate);
		
	}

	
	
}
