package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;

@Mapper
public interface InventorySchedulerMapper {
	
	// 임박 재고 조회 + 알림 처리
	List<InventoryDTO> selectImminentStock();
	
	// 만료 재고 조회
    List<InventoryDTO> selectExpiredStock();
    
}
