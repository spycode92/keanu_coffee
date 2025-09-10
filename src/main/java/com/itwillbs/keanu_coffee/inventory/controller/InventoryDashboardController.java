package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.inventory.service.InventoryDashboardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory/api")
public class InventoryDashboardController {
	private final InventoryDashboardService inventoryDashboardService;
	
	// 대시보드 JSP 열기
    @GetMapping("/dashboard")
    public String getDashboard() {
        return "inventory/inventoryDashboard"; // inventoryDashboard.jsp
    }
    
    // 현재 재고 KPI (총 재고 - (전날 출고 + 전날 출고폐기))
    @GetMapping("/kpi")
    @ResponseBody
    public Map<String, Object> getKpiData() {
    	int totalStock = inventoryDashboardService.selectTotalStock();              // 오늘 총 재고
        int outboundYesterday = inventoryDashboardService.selectYesterdayOutbound(); // 전날 출고 수량
        int disposalYesterday = inventoryDashboardService.selectYesterdayOutboundDisposal(); // 전날 출고폐기 수량

        int currentStock = totalStock - (outboundYesterday + disposalYesterday); // 현재 재고
        int changeQty = -(outboundYesterday + disposalYesterday);                // 증감 수량

        Map<String, Object> result = new HashMap<>();
        result.put("currentStock", currentStock);  
        result.put("changeQty", changeQty);        
        return result;
    }
    
    // 재고현황 (카테고리별/상품별) 조회
    @GetMapping("/inventory")
    @ResponseBody
    public List<TotalDashBoardDTO> getInventory() {
        return inventoryDashboardService.selectInventoryDashData();
    }

    @GetMapping("/locationUse")
    @ResponseBody
    public List<TotalDashBoardDTO> getLocationUse() {
        return inventoryDashboardService.selectLocationDashData();
    }
}











