package com.itwillbs.keanu_coffee.inbound.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.service.ExcelExportService;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;
import com.itwillbs.keanu_coffee.inbound.mapper.InboundMapper;
import com.itwillbs.keanu_coffee.inbound.service.InboundService;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	private final InboundService inboundService;
	private final ExcelExportService excelExportService;
	private final InboundMapper inboundMapper;
	private static final Logger log = LoggerFactory.getLogger(InboundController.class);
	
	// ====================================================================================================================================
	// 대시보드
	@GetMapping("/main")
	public String showInboundDashboard() {
		return "/inbound/inboundDashboard";
	}
	
	// ====================================================================================================================================
	// 입고조회
	@GetMapping("/management")
	public String showInboundManagement(
			@RequestParam(required = false) String simpleKeyword,
	        @RequestParam(required = false) String status,
	        @RequestParam(required = false) String orderInboundKeyword,
	        @RequestParam(required = false) String vendorKeyword,
	        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate inStartDate,
	        @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate inEndDate,
			@RequestParam(defaultValue = "1") int pageNum, Model model) {
		
		// 검색
	    Map<String, Object> searchParams = new HashMap<>();
	    searchParams.put("simpleKeyword", simpleKeyword);
	    searchParams.put("status", status);
	    searchParams.put("orderInboundKeyword", orderInboundKeyword);
	    searchParams.put("vendorKeyword", vendorKeyword);
	    searchParams.put("inStartDate", inStartDate);
	    searchParams.put("inEndDate", inEndDate);
	    
	    // 전체 개수
	    int totalCount = inboundService.getInboundCount(searchParams);
		
	    // 페이징
		int listLimit = 15; // 한 페이지당 표시할 목록 수\
		int startRow = (pageNum - 1) * listLimit;
	    PageInfoDTO pageInfo = new PageInfoDTO();
	    pageInfo.setPageNum(pageNum);
	    pageInfo.setMaxPage((int)Math.ceil(totalCount / (double)listLimit));
		
		// 리스트(검색조건 + 페이징)
	    List<InboundManagementDTO> orderDetailList = inboundService.getInboundList(searchParams, startRow, listLimit);
	    
	    model.addAttribute("pageInfo", pageInfo);
	    model.addAttribute("orderList", orderDetailList);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("searchParams", searchParams);

	    return "/inbound/inboundManagement";
	}

	// ====================================================================================================================================
	// 입고상세
	@GetMapping("/inboundDetail")
	public String showInboundDetail(@RequestParam(name="orderNumber", required=false) String orderNumber, 
									@RequestParam(name="ibwaitIdx", required=false) Integer ibwaitIdx,
									Model model) {
		
		// 1) 기본정보 보드 조회
	    InboundDetailDTO inboundDetailData = inboundService.getInboundDetailData(ibwaitIdx);
	    model.addAttribute("inboundDetailData", inboundDetailData);
		
	    // 2) 상품 상세 정보 조회
	    List<InboundProductDetailDTO> ibProductDetail = inboundService.getInboundProductDetail(orderNumber);
	    model.addAttribute("ibProductDetail", ibProductDetail);
	    
		return "/inbound/inboundDetail";
	}
	
	@PostMapping(path="/updateLocation", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> updateLocation(@RequestBody UpdateLocationReq req){
		log.info("[updateLocation] ibwaitIdx={}, inboundLocation={}", req.getIbwaitIdx(), req.getInboundLocation());
		inboundService.updateLocation(req.getIbwaitIdx(), req.getInboundLocation());
		return Map.of("ok", true, "ibwaitIdx", req.getIbwaitIdx(), "inboundLocation", req.getInboundLocation());
	}
	
	@GetMapping(path="/managerCandidates", produces="application/json")
	@ResponseBody
	public List<EmployeeInfoDTO> managerCandidates(){
		return inboundService.findManagers();
	}

	@PostMapping(path="/updateManagers", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> updateManagers(@RequestBody Map<String, Object> payload) {
	    List<Integer> ibwaitIdxList = (List<Integer>) payload.get("ibwaitIdxList");
	    Long managerIdx = Long.valueOf(payload.get("managerIdx").toString());
	    String managerName = payload.get("managerName").toString();

	    inboundService.updateManagers(ibwaitIdxList, managerIdx, managerName);

	    return Map.of(
	        "ok", true,
	        "count", ibwaitIdxList.size(),
	        "managerIdx", managerIdx,
	        "managerName", managerName
	    );
	}
	
	// ====================================================================================================================================
	// 입고검수
	@GetMapping("/inboundInspection")
	public String showInboundInspection(@RequestParam(name="orderNumber", required=false) String orderNumber, 
										@RequestParam(name="ibwaitIdx", required=false) Integer ibwaitIdx,
										Model model) {
		
	    InboundDetailDTO inboundDetailData = inboundService.getInboundDetailData(ibwaitIdx);
	    model.addAttribute("inboundDetailData", inboundDetailData);
		
	    List<InboundProductDetailDTO> ibProductDetail = inboundService.getInboundProductDetail(orderNumber);
	    model.addAttribute("ibProductDetail", ibProductDetail);
		
		return "/inbound/inboundInspection";
	}
	
	@PostMapping(path="/inspectionComplete", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> inspectionComplete(@RequestBody ReceiptProductDTO dto) {
		boolean exists = inboundService.findDataExists(dto.getIbwaitIdx(), dto.getProductIdx(), dto.getLotNumber());
		inboundService.inspectionCompleteUpdate(dto, exists);
		return Map.of("ok", true);
	}
	
	// 엑셀 생성 컨트롤러
	@GetMapping("/management/excel")
	public void downloadExcel(
            @RequestParam(value = "simpleKeyword", required = false) String simpleKeyword,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "orderInboundKeyword", required = false) String orderInboundKeyword,
            @RequestParam(value = "vendorKeyword", required = false) String vendorKeyword,
            @RequestParam(value = "inStartDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate inStartDate,
            @RequestParam(value = "inEndDate", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate inEndDate,
            HttpServletResponse response) throws IOException {

        // --- 검색 파라미터 정리 ---
        Map<String, Object> searchParams = new HashMap<>();
        searchParams.put("simpleKeyword", simpleKeyword != null ? simpleKeyword.trim() : null);
        searchParams.put("status", status != null ? status.trim() : null);
        searchParams.put("orderInboundKeyword", orderInboundKeyword != null ? orderInboundKeyword.trim() : null);
        searchParams.put("vendorKeyword", vendorKeyword != null ? vendorKeyword.trim() : null);
        searchParams.put("inStartDate", inStartDate);
        searchParams.put("inEndDate", inEndDate);

        // --- DB 조회 ---
        List<InboundManagementDTO> list = inboundMapper.selectInboundListForExcel(searchParams);

        // --- 엑셀 생성 ---
        Workbook workbook = excelExportService.createInboundManagementExcel(searchParams);

        // --- 응답 헤더 ---
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=inbound_management.xlsx");

        workbook.write(response.getOutputStream());
        workbook.close();
    }


	
	// ====================================================================================================================================
	// 입고등록
	@GetMapping("/inboundRegister")
	public String showInboundRegister() {
		return "/inbound/inboundRegister";
	}
	
	// 입고확정
	@GetMapping("/inboundConfirm")
	public String showInboundConfirm() {
		return "/inbound/inboundConfirm";
	}
	
	// ====================================================================================================================================
	// 내부 DTO 정의
	@Data
	public static class UpdateManagerReq {
		private Long ibwaitIdx;
		private Long managerIdx;
		private String managerName; 
	}
	
	@Data 
	public static class UpdateLocationReq { 
		private Long ibwaitIdx; 
		private String inboundLocation; 
	}
}
