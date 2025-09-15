package com.itwillbs.keanu_coffee.inventory.mapper;


import java.sql.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.ReceiptProductDTO2;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;


@Mapper
public interface InventoryActionsMapper {

	void insertWarehouse(WarehouseLocationDTO warehouseLocationDTO);

	String selectLastCurrentLocation();

	InventoryDTO selectQuantity(@Param("inventoryId") int inventoryId);

	void deleteRowInInventory(int inventoryId);

	void updateQuantitydecrease(@Param("inventoryId") int inventoryId, @Param("qty") int qty);

	void updateLocationOfInventory(@Param("inventoryId") int inventoryId, @Param("qtyMoving") int qtyMoving, @Param("employeeId") int employeeId);

	void insertLocationOfInventory(@Param("inventoryDTO") InventoryDTO inventoryDTO, @Param("qtyMoving") int qtyMoving, @Param("employeeId") int employeeId);

	void updateLocationOfInventory2(@Param("inventoryId") int inventoryId, @Param("qtyMoving") int qtyMoving, @Param("destinationName") String destinationName, @Param("locationIdxOfDestinationName") int locationIdxOfDestinationName);

//	int selectlocationIdxOfDestinationName(String destinationName);
	InventoryDTO selectlocationIdxOfDestinationName(String destinationName);

	void insertLocationOfInventory2(@Param("inventoryDTO") InventoryDTO inventoryDTO, @Param("qtyMoving") int qtyMoving, @Param("destinationName") String destinationName,
			@Param("locationIdxOfDestinationName") int locationIdxOfDestinationName);

	ReceiptProductDTO2 selectReceiptProduct(int receiptID);

	void insertLocationOfInventory3(
			@Param("receiptProductIdx") int receiptProductIdx,
			@Param("locationIdxOfDestinationName") int locationIdxOfDestinationName, 
			@Param("destinationName") String destinationName,
			@Param("productIdx") int productIdx, 
			@Param("qtyMoving") int qtyMoving, 
			@Param("lotNumber") String lotNumber, 
			@Param("manufactureDate") Date manufactureDate, 
			@Param("expirationDate") Date expirationDate);
	

	
	
	

//	    void insertOrder(OutboundOrderDTO order);
//	
//
//
//	    void insertItem(OutboundOrderItem item);
	


}
