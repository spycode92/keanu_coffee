package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;
import com.itwillbs.keanu_coffee.inventory.service.InventorySearchService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory")
public class InventorySearchController {
	private final InventorySearchService inventorySearchService;
	
	// KPI (총 SKU, 총 재고 수량)
	@GetMapping("/metrics") // 재고 관리 화면의 KPI 지표(=metrics)
	@ResponseBody
	public Map<String, Object> getMetrics() {
	    Map<String, Object> result = new HashMap<>();
	    
	    result.put("totalSku", inventorySearchService.selectTotalSku());
	    result.put("totalQty", inventorySearchService.selectTotalQuantity());
	    
	    return result;
	}
	
	// 재고 리스트 조회 (페이징 + 검색조건 대비)
    @GetMapping("/stockCheck")
    public String getStockCheck(
    		Model model,
            @RequestParam(defaultValue = "1") int pageNum,       // 페이지 번호
            @RequestParam(defaultValue = "") String keyword,     // 상품명/코드 검색
            @RequestParam(defaultValue = "") String location,    // 로케이션명
            @RequestParam(defaultValue = "전체") String locationType, // 로케이션 유형
            @RequestParam(defaultValue = "") String mfgDate,   // 제조일자
            @RequestParam(defaultValue = "") String expDate,   // 유통기한
            @RequestParam(defaultValue = "전체") String stockStatus,   // 재고 상태
            @RequestParam(defaultValue = "전체") String outboundStatus, // 출고 여부
            @RequestParam(defaultValue = "") String sortOption,         // 날짜 정렬
            @RequestParam(defaultValue = "") String qtySort            // 수량 정렬  
    ) {

        int listLimit = 10; // 한 페이지에 보여줄 행 개수

        // 총 데이터 개수 가져오기
        int inventoryCount = inventorySearchService.selectInventoryCount(
                keyword, location, locationType, mfgDate, expDate,
                stockStatus, outboundStatus
        );

        if (inventoryCount > 0) {
            // 페이징 계산
            PageInfoDTO pageInfo = PageUtil.paging(listLimit, inventoryCount, pageNum, 5);

            // 현재 페이지 데이터 조회
            List<Map<String, Object>> list = inventorySearchService.selectReceiptProductList(
                    pageInfo.getStartRow(),
                    listLimit,
                    keyword, location, locationType, mfgDate, expDate,
                    stockStatus, outboundStatus, sortOption, qtySort
            );

            model.addAttribute("inventoryList", list);
            model.addAttribute("pageInfo", pageInfo);
        }

        // 검색 조건 & 페이지 정보 JSP로 다시 전달
        model.addAttribute("pageNum", pageNum);
        model.addAttribute("keyword", keyword);
        model.addAttribute("location", location);
        model.addAttribute("locationType", locationType);
        model.addAttribute("mfgDate", mfgDate);
        model.addAttribute("expDate", expDate);
        model.addAttribute("stockStatus", stockStatus); 
        model.addAttribute("outboundStatus", outboundStatus);
        model.addAttribute("sortOption", sortOption);
        model.addAttribute("qtySort", qtySort);

        return "inventory/stockCheck";
    }
    
    // 재고 상세 조회 모달창 (Ajax)
    @GetMapping("/detail")
    @ResponseBody
    public Map<String, Object> getInventoryDetail(@RequestParam("idx") int inventoryIdx) {
        // 서비스에서 단건 조회 (상세정보 + 로케이션 분포까지 조회)
        return inventorySearchService.selectInventoryDetail(inventoryIdx);
    }
    
    
}
