package com.itwillbs.keanu_coffee.inventory.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventorySearchMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InventorySearchService {
	private final InventorySearchMapper inventorySearchMapper;
	
	// 총 SKU
	public int selectTotalSku() {
	    return inventorySearchMapper.selectTotalSku();
	}
	
	// 총 재고 수량
	public int selectTotalQuantity() {
	    return inventorySearchMapper.selectTotalQuantity();
	}
	
	// 카테고리 목록 조회
    public List<CommonCodeDTO> selectCategoryList(String groupCode) {
        return inventorySearchMapper.selectCategoryList(groupCode);
    }
	
	// 총 데이터 개수
    public int selectInventoryCount(
            String keyword, String location, String locationType,
            String mfgDate, String expDate,
            String stockStatus, String outboundStatus,
            String sortOption, String qtySort,
            String category
    ) {
        return inventorySearchMapper.selectInventoryCount(
                keyword, location, locationType,
                mfgDate, expDate,
                stockStatus, outboundStatus,
                sortOption, qtySort,
                category
        );
    }
    
    // 리스트 조회
    public List<Map<String, Object>> selectReceiptProductList(
            int startRow, int listLimit,
            String keyword, String location, String locationType,
            String mfgDate, String expDate,
            String stockStatus, String outboundStatus,
            String sortOption, String qtySort,
            String category
    ) {
        return inventorySearchMapper.selectReceiptProductList(
                startRow, listLimit,
                keyword, location, locationType,
                mfgDate, expDate,
                stockStatus, outboundStatus,
                sortOption, qtySort,
                category
        );
    }
    
    // ---------- 재고 상세 모달창 (Ajax) ----------
    public Map<String, Object> selectInventoryDetail(int receiptProductIdx) {
        // 재고 상세
    	Map<String, Object> detail = inventorySearchMapper.selectInventoryDetail(receiptProductIdx);
    	
    	if (detail == null) {
            detail = new HashMap<>(); // null 방지
        }
    	
        // 로케이션 분포
    	List<Map<String, Object>> locations = inventorySearchMapper.selectLocationDistribution(receiptProductIdx);
        if (locations == null) {
            locations = new ArrayList<>(); // null 방지
        }
        
        detail.put("locations", locations);
        
        return detail;
    }
    
}