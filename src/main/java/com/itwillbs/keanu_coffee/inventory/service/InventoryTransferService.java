package com.itwillbs.keanu_coffee.inventory.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryTransferMapper;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InventoryTransferService {
	private final InventoryTransferMapper inventoryTransferMapper;
	
	// 적정재고 저장용
    private static final Map<Integer, Integer> targetStockCache = new HashMap<>();

    // 파레트존 재고 조회
    public List<InventoryDTO> selectPalletZoneStock() {
        return inventoryTransferMapper.selectPalletZoneStock();
    }

    // 피킹존 재고 조회
    public List<InventoryDTO> selectPickingZoneStock() {
        return inventoryTransferMapper.selectPickingZoneStock();
    }

    // 최근 7일 출고량으로 적정재고 계산
    public void updatePickingZoneTargetStock() {
    	// 최근 7일간 출고량 가져오기
        List<OutboundOrderItemDTO> avgList = inventoryTransferMapper.selectLast7DaysOutbound();
        
        targetStockCache.clear();   // 기존 캐시 초기화
        for (OutboundOrderItemDTO dto : avgList) {
            int avg = dto.getQuantity() / 7;   // 하루 평균 출고량 (하루 평균(총합/7) 계산.)
            int target = avg * 2;              // 이틀치 = 적정재고(100%) / (그 평균의 2일치(avg * 2)를 적정재고(100%)로 설정.)
            targetStockCache.put(dto.getProductIdx(), target); // 이 값을 targetStockCache 라는 Map<productIdx, targetQty> 에 저장.
        }
    }

    // 적정재고 캐시 가져오기
    public Map<Integer, Integer> getTargetStockCache() {
        return targetStockCache;
    }
	
}
