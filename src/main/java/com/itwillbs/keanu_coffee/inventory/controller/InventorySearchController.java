package com.itwillbs.keanu_coffee.inventory.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.DisposalDTO;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.dto.SweetAlertIcon;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.MakeAlert;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryUpdateDTO;
import com.itwillbs.keanu_coffee.inventory.service.InventorySearchService;
import com.itwillbs.keanu_coffee.inventory.service.InventoryService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory")
public class InventorySearchController {
	private final InventorySearchService inventorySearchService;
	private final InventoryService inventoryService;
	
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
            @RequestParam(defaultValue = "1") int pageNum,              // 페이지 번호
            @RequestParam(defaultValue = "") String keyword,            // 상품명/코드 검색
            @RequestParam(defaultValue = "") String location,           // 로케이션명
            @RequestParam(defaultValue = "전체") String locationType,   // 로케이션 유형
            @RequestParam(defaultValue = "") String mfgDate,            // 제조일자
            @RequestParam(defaultValue = "") String expDate,            // 유통기한
            @RequestParam(defaultValue = "전체") String stockStatus,    // 재고 상태
            @RequestParam(defaultValue = "전체") String outboundStatus, // 출고 여부
            @RequestParam(defaultValue = "") String sortOption,         // 날짜 정렬
            @RequestParam(defaultValue = "") String qtySort,            // 수량 정렬
            @RequestParam(defaultValue = "") String category) {       // 카테고리

        int listLimit = 10; // 한 페이지에 보여줄 행 개수

        // 총 데이터 개수
        int inventoryCount = inventorySearchService.selectInventoryCount(
                keyword, location, locationType, mfgDate, expDate,
                stockStatus, outboundStatus, sortOption, qtySort, category 
        );

        if (inventoryCount > 0) {
            // 페이징 계산
            PageInfoDTO pageInfo = PageUtil.paging(listLimit, inventoryCount, pageNum, 5);
            
            // 잘못된 페이지 번호 방어 로직 추가
            if (pageNum < 1 || pageNum > pageInfo.getMaxPage()) {
                model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
                model.addAttribute("targetURL", "/inventory/stockCheck");
                return "commons/result_process";
            }
            
            // 현재 페이지 데이터 조회
            List<Map<String, Object>> list = inventorySearchService.selectReceiptProductList(
                    pageInfo.getStartRow(),
                    listLimit,
                    keyword, location, locationType, mfgDate, expDate,
                    stockStatus, outboundStatus, sortOption, qtySort, category 
            );

            model.addAttribute("inventoryList", list);
            model.addAttribute("pageInfo", pageInfo);
        }
        
        // 카테고리 목록 조회 (공통코드)
        List<CommonCodeDTO> categoryList = inventorySearchService.selectCategoryList("CATEGORY");
        model.addAttribute("categoryList", categoryList);
        
        // 검색 조건 & 페이지 정보 JSP로 다시 전달
        model.addAttribute("keyword", keyword);
        model.addAttribute("location", location);
        model.addAttribute("locationType", locationType);
        model.addAttribute("mfgDate", mfgDate);
        model.addAttribute("expDate", expDate);
        model.addAttribute("stockStatus", stockStatus); 
        model.addAttribute("outboundStatus", outboundStatus);
        model.addAttribute("sortOption", sortOption);
        model.addAttribute("qtySort", qtySort);
        model.addAttribute("category", category); // 선택된 카테고리 유지

        return "inventory/stockCheck";
    }
    
    // 재고 상세 조회 모달창 (Ajax)
    @GetMapping("/detail")
    @ResponseBody
    public Map<String, Object> getInventoryDetail(@RequestParam("idx") int receiptProductIdx) {
        return inventorySearchService.selectInventoryDetail(receiptProductIdx);
    }
    
    // 수량 조절 업데이트
    @PostMapping("/updateInventory")
    public String modifyInventoryQuantity(
    		@ModelAttribute InventoryUpdateDTO request, 
    		Authentication authentication,
    		RedirectAttributes redirectAttributes) {
    	
		EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
		Integer empIdx = empDetail.getEmpIdx();
		
    	try {
    		inventoryService.updateInventoryQuantity(request, empIdx);
    		MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.SUCCESS, "성공", "재고수량변경");
    	} catch (Exception e) {
    		e.printStackTrace();
    		MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "실패", "재고수량업데이트실패");
		}
    	
    	return "redirect:/inventory/stockCheck";
    }

    // 수량 조절 업데이트
    @PostMapping("/disposalInventory")
    public String disposalInventoryQuantity(
    		@ModelAttribute InventoryUpdateDTO request,
    		@ModelAttribute DisposalDTO disposal,
    		Authentication authentication,
    		RedirectAttributes redirectAttributes) {
    	
    	EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
    	Integer empIdx = empDetail.getEmpIdx();
    	
    	try {
    		inventoryService.disposalInventoryQuantity(request, disposal, empIdx);
    		MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.SUCCESS, "성공", "재고수량변경");
    	} catch (Exception e) {
    		e.printStackTrace();
    		MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "실패", "재고수량업데이트실패");
    	}
    	
    	return "redirect:/inventory/stockCheck";
    }
    
}
