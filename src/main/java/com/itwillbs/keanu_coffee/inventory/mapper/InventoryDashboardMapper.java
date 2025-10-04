package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;

@Mapper
public interface InventoryDashboardMapper {
	
	// 현재 재고 KPI (총 재고 - (전날 출고 + 전날 출고폐기))
	// 오늘 총 재고
    int selectTotalStock();

    // 전날 출고 수량
    int selectYesterdayOutbound();

    // 전날 출고 폐기 수량
    int selectYesterdayOutboundDisposal();
	// --------------------------------------------------------
	
	// 재고현황 (카테고리별/상품별) 조회
	List<TotalDashBoardDTO> selectInventoryDashData();
	
	// 로케이션 용적률 조회
	List<TotalDashBoardDTO> selectLocationDashData();

	
}
