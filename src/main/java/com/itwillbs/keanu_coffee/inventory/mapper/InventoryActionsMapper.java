package com.itwillbs.keanu_coffee.inventory.mapper;


import org.apache.ibatis.annotations.Mapper;


import com.itwillbs.keanu_coffee.inventory.dto.CreateWarehouseDTO;


@Mapper
public interface InventoryActionsMapper {

	void insertWarehouse(CreateWarehouseDTO createWarehouseDTO);
	

	
	
	

//	    void insertOrder(OutboundOrderDTO order);
//	
//
//
//	    void insertItem(OutboundOrderItem item);
	


}
