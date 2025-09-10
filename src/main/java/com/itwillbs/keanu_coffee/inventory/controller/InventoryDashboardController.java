package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.inventory.service.InventoryDashboardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory/api")
public class InventoryDashboardController {
	private final InventoryDashboardService inventoryDashboardService;
	
	// 총 재고 수량 조회
    @GetMapping("/total-stock")
    @ResponseBody
    public Map<String, Object> getTotalStock() {
        int totalStock = inventoryDashboardService.selectTotalStock();

        Map<String, Object> result = new HashMap<>();
        result.put("totalStock", totalStock);

        return result; // JSON 형태 { "totalStock": 3150 }
    }
	
    // 금일 입고/출고 건수 조회
    @GetMapping("/today-inout")
    @ResponseBody
    public Map<String, Object> getTodayInOut() {
        int inbound = inventoryDashboardService.selectTodayInboundCount();
        int outbound = inventoryDashboardService.selectTodayOutboundCount();

        Map<String, Object> result = new HashMap<>();
        result.put("inbound", inbound);
        result.put("outbound", outbound);

        return result; // JSON { "inbound": 15, "outbound": 10 }
    }
	
    // 로케이션 용적률 조회
    @GetMapping("/location-usage")
    @ResponseBody
    public List<Map<String, Object>> getLocationUsage() {
        return inventoryDashboardService.selectLocationUsage();
    }
    
	// 카테고리별 재고 합계 조회
	@GetMapping("/category-stock")
    @ResponseBody
    public Map<String, Object> getCategoryStock() {
        // DB에서 카테고리별 재고 데이터 가져오기
        List<Map<String, Object>> list = inventoryDashboardService.selectCategoryStock();

        // 카테고리 이름과 수량을 담을 리스트
        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();

        // list 안에 있는 값들을 하나씩 꺼내서 labels, values에 넣기
        for (Map<String, Object> row : list) {
            String categoryName = (String) row.get("categoryName"); // 카테고리 이름
            int totalQuantity = ((Number) row.get("totalQuantity")).intValue(); // 합계

            labels.add(categoryName);
            values.add(totalQuantity);
        }

        // 최종 결과를 result에 담기
        Map<String, Object> result = new HashMap<>();
        result.put("labels", labels);
        result.put("values", values);

        // JSON 형태로 JSP에 반환됨
        return result;
    }
}











