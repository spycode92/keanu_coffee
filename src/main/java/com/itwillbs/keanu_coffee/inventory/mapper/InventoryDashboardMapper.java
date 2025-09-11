package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface InventoryDashboardMapper {
	
	// 총 재고 수량 조회
	int selectTotalStock();
	
	// 금일 입고 건수 조회
	int selectTodayInboundCount();
	
	// 금일 출고 건수 조회
	int selectTodayOutboundCount();
	
	// 로케이션 용적률 조회
	List<Map<String, Object>> selectLocationUsage();
	
	// 카테고리별 재고 합계 조회
	List<Map<String, Object>> selectCategoryStock();
	
}
