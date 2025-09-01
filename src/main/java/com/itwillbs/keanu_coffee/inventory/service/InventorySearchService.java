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
	
	// 전체 데이터 개수
    public int getInventoryCount(String searchType, String searchKeyword) {
        return inventorySearchMapper.selectInventoryCount(searchType, searchKeyword);
    }

    // 페이징 데이터 조회
    public List<Map<String, Object>> getReceiptProductList(int startRow, int listLimit,
                                                           String searchType, String searchKeyword) {
        return inventorySearchMapper.selectReceiptProductList(startRow, listLimit, searchType, searchKeyword);
    }
    
}