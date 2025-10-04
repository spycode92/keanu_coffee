package com.itwillbs.keanu_coffee.inventory.mapper;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;

@Mapper
public interface InventoryTransferMapper {
	
	// 파레트존 재고 조회
    List<InventoryDTO> selectPalletZoneStock();

    // 피킹존 재고 조회
    List<InventoryDTO> selectPickingZoneStock();

    // 최근 7일 출고량 → Map으로 받음
    List<Map<String, Object>> selectLast7DaysOutbound();

    // 피킹존 보충 대상
    List<Map<String, Object>> selectPickingZoneNeedsReplenishment();
    
}