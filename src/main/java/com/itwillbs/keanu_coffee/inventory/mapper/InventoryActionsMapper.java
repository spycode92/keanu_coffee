package com.itwillbs.keanu_coffee.inventory.mapper;


import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;


@Mapper
public interface InventoryActionsMapper {

	void insertWarehouse(WarehouseLocationDTO warehouseLocationDTO);

	String selectLastCurrentLocation();

	InventoryDTO selectQuantity(@Param("inventoryId") int inventoryId);

	void deleteRowInInventory(int inventoryId);

	void updateQuantitydecrease(@Param("inventoryId") int inventoryId, @Param("qty") int qty);

	void updateLocationOfInventory(@Param("inventoryId") int inventoryId, @Param("qtyMoving") int qtyMoving, @Param("employeeId") int employeeId);
	

	
	
	

//	    void insertOrder(OutboundOrderDTO order);
//	
//
//
//	    void insertItem(OutboundOrderItem item);
	


}
