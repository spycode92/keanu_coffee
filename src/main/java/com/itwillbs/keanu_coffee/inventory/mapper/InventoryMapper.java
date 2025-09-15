package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;

@Mapper
public interface InventoryMapper {

	WarehouseInfoDTO selectWarehouseInfo();

	List<InventoryDTO> selectInventoryItemsInEmployeesVirtualLocation(int empIdx);

//	List<InventoryDTO> selectInventoryThatNeedsToMoveFromInbound();
//
//	List<InventoryDTO> selectInventoryThatNeedsToMoveToOutbound();

}
