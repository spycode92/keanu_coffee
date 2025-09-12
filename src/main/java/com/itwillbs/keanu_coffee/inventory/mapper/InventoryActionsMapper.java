package com.itwillbs.keanu_coffee.inventory.mapper;


import org.apache.ibatis.annotations.Mapper;


import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;


@Mapper
public interface InventoryActionsMapper {

	void insertWarehouse(WarehouseLocationDTO warehouseLocationDTO);

	String selectLastCurrentLocation();
	

	
	
	

//	    void insertOrder(OutboundOrderDTO order);
//	
//
//
//	    void insertItem(OutboundOrderItem item);
	


}
