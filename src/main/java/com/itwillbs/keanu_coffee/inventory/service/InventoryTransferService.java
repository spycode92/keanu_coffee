package com.itwillbs.keanu_coffee.inventory.service;


import java.math.BigDecimal;
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
        // 최근 7일 출고량 가져오기 → resultType=map 이므로 Map으로 받음
        List<Map<String, Object>> avgList = inventoryTransferMapper.selectLast7DaysOutbound();

        targetStockCache.clear(); // 기존 캐시 초기화

        for (Map<String, Object> row : avgList) {
            // Map에서 값 꺼내오기
            Integer productIdx = (Integer) row.get("productIdx");
            Long totalOutbound = ((BigDecimal) row.get("totalOutbound")).longValue(); // ✅ BigDecimal → long 변환

            if (productIdx != null) {
                int avg = (int) (totalOutbound / 7); // 하루 평균 출고량
                int target = avg * 2;               // 이틀치 → 적정재고(100%)

                targetStockCache.put(productIdx, target);
            }
        }

        // 확인용 로그
        System.out.println("✅ targetStockCache 업데이트 완료: " + targetStockCache);
    }

    // 적정재고 캐시 가져오기
    public Map<Integer, Integer> getTargetStockCache() {
        return targetStockCache;
    }

    // 피킹존 보충 대상 조회
    public List<Map<String, Object>> selectPickingZoneNeedsReplenishment() {
        return inventoryTransferMapper.selectPickingZoneNeedsReplenishment();
    }
	
}
