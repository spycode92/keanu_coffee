package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.inventory.mapper.InventorySearchMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InventorySearchService {
	private final InventorySearchMapper inventorySearchMapper;
	
	// 재고 리스트(입고완료 데이터) 조회
	public List<Map<String, Object>> getReceiptProductList() {
		return inventorySearchMapper.selectReceiptProductList();
	}
	
	
	
}
