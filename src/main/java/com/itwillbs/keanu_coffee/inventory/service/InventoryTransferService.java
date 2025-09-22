package com.itwillbs.keanu_coffee.inventory.service;


import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryTransferMapper;

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

    // 최근 7일 출고량으로 적정재고 계산 (주 1회 실행)
    public void updatePickingZoneTargetStock() {
        List<Map<String, Object>> avgList = inventoryTransferMapper.selectLast7DaysOutbound();
        targetStockCache.clear();

        for (Map<String, Object> row : avgList) {
            Integer productIdx = (Integer) row.get("productIdx");
            Long totalOutbound = ((BigDecimal) row.get("totalOutbound")).longValue();

            if (productIdx != null) {
                int avg = (int) (totalOutbound / 7); // 하루 평균
                int target = avg * 2;               // 이틀치
                targetStockCache.put(productIdx, target);
            }
        }


        // 확인용 로그
//        System.out.println("✅ targetStockCache 업데이트 완료: " + targetStockCache);

    }

    // 적정재고 캐시 가져오기
    public Map<Integer, Integer> getTargetStockCache() {
        return targetStockCache;
    }

    // 매일 실행해서 보충 필요 여부 확인
    public void checkPickingZoneNeedsReplenishment() {
        Map<Integer, Integer> targetMap = getTargetStockCache(); // 기준 불러오기
        List<InventoryDTO> pickingList = selectPickingZoneStock();

        for (InventoryDTO stock : pickingList) {
            Integer productIdx = stock.getProductIdx();
            Integer target = targetMap.get(productIdx);

            if (target != null && stock.getQuantity() < target) {
                System.out.println("⚠️ 보충 필요 → 상품: "
                    + productIdx + " / 현재: " + stock.getQuantity() + " / 기준: " + target);
            }
        }
    }
}