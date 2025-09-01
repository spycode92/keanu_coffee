package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;
import com.itwillbs.keanu_coffee.inventory.service.InventorySearchService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory")
public class InventorySearchController {
	private final InventorySearchService inventorySearchService;
	
	// 재고 리스트 조회 (페이징 + 검색조건 대비)
    @GetMapping("/stockCheck")
    public String getStockCheck(
            Model model,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "") String searchType,
            @RequestParam(defaultValue = "") String searchKeyword) {

        int listLimit = 10; // 한 페이지에 보여줄 행 개수

        // 총 데이터 개수 가져오기
        int inventoryCount = inventorySearchService.getInventoryCount(searchType, searchKeyword);

        if (inventoryCount > 0) {
            // 페이징 계산
            PageInfoDTO pageInfo = PageUtil.paging(listLimit, inventoryCount, pageNum, 5);

            // 현재 페이지 데이터 조회
            List<Map<String, Object>> list = inventorySearchService.getReceiptProductList(
                    pageInfo.getStartRow(),
                    listLimit,
                    searchType,
                    searchKeyword
            );

            model.addAttribute("inventoryList", list);
            model.addAttribute("pageInfo", pageInfo);
        }

        model.addAttribute("pageNum", pageNum);
        model.addAttribute("searchType", searchType);
        model.addAttribute("searchKeyword", searchKeyword);

        return "inventory/stockCheck";
    }
}
