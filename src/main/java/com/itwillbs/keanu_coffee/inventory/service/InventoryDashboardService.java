package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.inventory.mapper.InventoryDashboardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InventoryDashboardService {
	private final InventoryDashboardMapper inventoryDashboardMapper;
	
	// 총 재고 수량 조회
	public int selectTotalStock() {
		return inventoryDashboardMapper.selectTotalStock();
	}
	
	// 금일 입고 건수 조회
	public int selectTodayInboundCount() {
		return inventoryDashboardMapper.selectTodayInboundCount();
	}
	
	// 금일 출고 건수 조회
	public int selectTodayOutboundCount() {
		return inventoryDashboardMapper.selectTodayOutboundCount();
	}
	
	// 로케이션 용적률 조회
	public List<Map<String, Object>> selectLocationUsage() {
		return inventoryDashboardMapper.selectLocationUsage();
	}
	
	// 카테고리별 재고 합계 조회
	public List<Map<String, Object>> selectCategoryStock() {
		return inventoryDashboardMapper.selectCategoryStock();
	}
	

}
