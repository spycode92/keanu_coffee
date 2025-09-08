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
	
	// 총 SKU
	public int selectTotalSku() {
	    return inventorySearchMapper.selectTotalSku();
	}
	
	// 총 재고 수량
	public int selectTotalQuantity() {
	    return inventorySearchMapper.selectTotalQuantity();
	}
	
	// 총 데이터 개수
	public int selectInventoryCount(
            String keyword, String location, String locationType,
            String mfgDate, String expDate,
            String stockStatus, String outboundStatus
    ) {
        return inventorySearchMapper.selectInventoryCount(
                keyword, location, locationType,
                mfgDate, expDate,
                stockStatus, outboundStatus
        );
    }

	 // 리스트 조회
    public List<Map<String, Object>> selectReceiptProductList(
            int startRow, int listLimit,
            String keyword, String location, String locationType,
            String mfgDate, String expDate,
            String stockStatus, String outboundStatus,
            String sortOption, String qtySort
    ) {
        return inventorySearchMapper.selectReceiptProductList(
                startRow, listLimit,
                keyword, location, locationType,
                mfgDate, expDate,
                stockStatus, outboundStatus,
                sortOption, qtySort
        );
    }
    
    // 재고 상세 조회 모달창 (Ajax)
    public Map<String, Object> selectInventoryDetail(int inventoryIdx) {
        return inventorySearchMapper.selectInventoryDetail(inventoryIdx);
    }
    
    
}