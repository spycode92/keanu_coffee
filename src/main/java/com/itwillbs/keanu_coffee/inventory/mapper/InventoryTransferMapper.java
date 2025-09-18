package com.itwillbs.keanu_coffee.inventory.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;

@Mapper
public interface InventoryTransferMapper {
	
	// 파레트존 재고 조회
    List<InventoryDTO> selectPalletZoneStock();

    // 피킹존 재고 조회
    List<InventoryDTO> selectPickingZoneStock();

    // 최근 7일 출고량 조회
    List<OutboundOrderItemDTO> selectLast7DaysOutbound();
    
}
