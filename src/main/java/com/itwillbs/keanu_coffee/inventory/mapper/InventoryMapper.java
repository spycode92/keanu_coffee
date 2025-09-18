package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.common.dto.DisposalDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryUpdateDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;

@Mapper
public interface InventoryMapper {

	WarehouseInfoDTO selectWarehouseInfo();

	List<InventoryDTO> selectInventoryItemsInEmployeesVirtualLocation(int empIdx);

	// 재고수량 업데이트
	void updateInventoryQuantity(InventoryUpdateDTO request);

	// 폐기 등록
	void insertDisposal(DisposalDTO disposal);

//	List<InventoryDTO> selectInventoryThatNeedsToMoveFromInbound();
//
//	List<InventoryDTO> selectInventoryThatNeedsToMoveToOutbound();

}
