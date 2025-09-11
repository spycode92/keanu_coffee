package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.common.dto.WebSocketDTO;
import com.itwillbs.keanu_coffee.inventory.service.InventoryDashboardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory/api")
public class InventoryDashboardController {
	private final InventoryDashboardService inventoryDashboardService;
	
	// ✅ 웹소켓 발사용 (테스트 용도)
    private final SimpMessagingTemplate simpMessagingTemplate;
	
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
    
    // 로케이션 용적률 조회
    @GetMapping("/locationUse")
    @ResponseBody
    public List<TotalDashBoardDTO> getLocationUse() {
        return inventoryDashboardService.selectLocationDashData();
    }
    
    /* =======================================================================
	    🚨 테스트용 API (안전하게 재고 대시보드 웹소켓 발사 확인)
	    - URL : /inventory/api/test-websocket
	    - 기능 : /topic/inventory 채널로 임시 메시지 전송
	    - 발표/운영 시 반드시 삭제
	 ======================================================================= */
     @GetMapping(value = "/test-websocket", produces = "text/plain;charset=UTF-8")
	 @ResponseBody
	 public String testWebSocket() {
	     WebSocketDTO msg = new WebSocketDTO();
	     msg.setRoomId("inventory");
	     msg.setSender("system"); // or 로그인 사용자
	     msg.setMessage("재고 변경 발생!");

	     simpMessagingTemplate.convertAndSend("/topic/inventory", msg);
	     return "웹소켓 메시지 발사 완료!";
	 }
	 
}











