package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryDashboardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InventoryDashboardService {
	private final InventoryDashboardMapper inventoryDashboardMapper;
	
	// 현재 재고 KPI (총 재고 - (전날 출고 + 전날 출고폐기))
	// 오늘 총 재고
    public int selectTotalStock() {
        return inventoryDashboardMapper.selectTotalStock();
    }

    // 전날 출고 수량
    public int selectYesterdayOutbound() {
        return inventoryDashboardMapper.selectYesterdayOutbound();
    }

    // 전날 출고 폐기 수량
    public int selectYesterdayOutboundDisposal() {
        return inventoryDashboardMapper.selectYesterdayOutboundDisposal();
    }
	// -----------------------------------------------------------
	
	// 재고현황 (카테고리별/상품별) 조회
	public List<TotalDashBoardDTO> selectInventoryDashData() {
        return inventoryDashboardMapper.selectInventoryDashData();
    }

    // 로케이션 용적률 조회
	public List<TotalDashBoardDTO> selectLocationDashData() {
        List<TotalDashBoardDTO> dash = inventoryDashboardMapper.selectLocationDashData();

        // 상품 부피값 보정 로직
        for (TotalDashBoardDTO d : dash) {
            long productVolume = d.getProductVolume();

            switch ((int) productVolume) {
                case 3: d.setProductVolume(17850); break;
                case 4: d.setProductVolume(35588); break;
                case 5: d.setProductVolume(60384); break;
            }
        }

        return dash;
    }

}
