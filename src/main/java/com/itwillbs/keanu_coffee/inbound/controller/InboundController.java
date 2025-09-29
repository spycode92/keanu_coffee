package com.itwillbs.keanu_coffee.inbound.controller;

import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
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
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.service.ExcelExportService;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;
import com.itwillbs.keanu_coffee.inbound.dto.CommitInventoryDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundStatusHistoryDTO;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;
import com.itwillbs.keanu_coffee.inbound.mapper.InboundMapper;
import com.itwillbs.keanu_coffee.inbound.service.InboundService;

import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	private final InboundService inboundService;
	private final ExcelExportService excelExportService;
	private final InboundMapper inboundMapper;
//	private static final Logger log = LoggerFactory.getLogger(InboundController.class);
	
	// ====================================================================================================================================
	// 대시보드
	@GetMapping("/main")
	public String showInboundDashboard() {
		return "/inbound/inboundDashboard";
	}
	
	// ====================================================================================================================================
	// 입고조회
	@GetMapping("/management")
	public Object showInboundManagement(
	        @RequestParam(required = false) String simpleKeyword,
	        @RequestParam(required = false) String status,
	        @RequestParam(required = false) String orderInboundKeyword,
	        @RequestParam(required = false) String vendorKeyword,
	        @RequestParam(required = false) String inStartDate,
	        @RequestParam(required = false) String inEndDate,
	        @RequestParam(required = false) String managerKeyword,
	        @RequestParam(defaultValue = "1") int pageNum,
	        Model model,
	        HttpServletRequest request) {

	    // --- 날짜 변환 ---
	    LocalDate start = null;
	    LocalDate end = null;
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	    if (inStartDate != null && !inStartDate.isBlank()) start = LocalDate.parse(inStartDate, formatter);
	    if (inEndDate   != null && !inEndDate.isBlank())   end   = LocalDate.parse(inEndDate, formatter);

	    // --- 검색 파라미터 ---
	    Map<String, Object> searchParams = new HashMap<>();
	    searchParams.put("simpleKeyword", simpleKeyword);
	    searchParams.put("status", status);
	    searchParams.put("orderInboundKeyword", orderInboundKeyword);
	    searchParams.put("vendorKeyword", vendorKeyword);
	    searchParams.put("inStartDate", start);
	    searchParams.put("inEndDate", end);
	    searchParams.put("managerKeyword", managerKeyword);
	    
	    log.info(">>>>>>>>>>>>>>>> managerKeyword : " + managerKeyword);

	    // --- 전체 개수/페이징/리스트 ---
	    int totalCount = inboundService.getInboundCount(searchParams);
	    int listLimit = 10;
	    int startRow = (pageNum - 1) * listLimit;

	    PageInfoDTO pageInfo = new PageInfoDTO();
	    pageInfo.setPageNum(pageNum);
	    pageInfo.setMaxPage((int) Math.ceil(totalCount / (double) listLimit));

	    List<InboundManagementDTO> orderDetailList = inboundService.getInboundList(searchParams, startRow, listLimit);

	    // --- Ajax 여부 판단: X-Requested-With 또는 Accept 헤더에 application/json 포함 ---
	    String xrw = request.getHeader("X-Requested-With");
	    String accept = request.getHeader("Accept");
	    boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(xrw) || (accept != null && accept.contains("application/json"));

	    if (isAjax) {
	        Map<String, Object> payload = Map.of(
	            "list", orderDetailList,
	            "totalCount", totalCount,
	            "pageInfo", pageInfo
	        );
	        return ResponseEntity.ok(payload); // ★ JSON 보장
	    }

	    // --- JSP 렌더링 ---
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
//	    log.info("inboundDetailData : " + inboundDetailData);
	    
	    // 2) 상품 상세 정보 조회
	    List<InboundProductDetailDTO> ibProductDetail = inboundService.getInboundProductDetail(orderNumber);
	    model.addAttribute("ibProductDetail", ibProductDetail);
	    
	    // 3) 로그 관련
	    List<InboundStatusHistoryDTO> historyList = inboundMapper.selectInboundStatusHistory(ibwaitIdx);
	    model.addAttribute("historyList", historyList);
	    
	    
	    
		return "/inbound/inboundDetail";
	}
	
	// 위치지정
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
	    if (inboundDetailData != null && "대기".equals(inboundDetailData.getInboundStatus())) {
	        inboundService.updateInboundStatusInspection(ibwaitIdx, "검수중");
	        inboundDetailData.setInboundStatus("검수중"); // 화면에도 반영
	    }
	    model.addAttribute("inboundDetailData", inboundDetailData);
		
	    List<InboundProductDetailDTO> ibProductDetail = inboundService.getInboundProductDetail(orderNumber);
	    model.addAttribute("ibProductDetail", ibProductDetail);
		
		return "/inbound/inboundInspection";
	}
	
	// 검수완료
	@PostMapping(path="/inspectionComplete", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String,Object> inspectionComplete(@RequestBody ReceiptProductDTO dto, Authentication authentication) {
		// 현재 로그인 사용자 정보 가져오기
		EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
		Integer empIdx = empDetail.getEmpIdx();
		dto.setEmpIdx(empIdx);
		
		// 데이터 존재 여부 확인 후 Insert or Update
		boolean exists = inboundService.findDataExists(dto.getIbwaitIdx(), dto.getProductIdx(), dto.getLotNumber());
	    inboundService.inspectionCompleteUpdate(dto, exists);

	    return Map.of("ok", true, "empIdx", empIdx, "receiptProductIdx", dto.getReceiptProductIdx());
	}
	
	
	// 입고완료 → INVENTORY 등록 + 상태 변경
	@PostMapping(path="/commitInbound", consumes="application/json", produces="application/json")
	@ResponseBody
	public Map<String, Object> commitInbound(@RequestBody CommitInventoryDTO req) {
	    try {
	        // 재고 등록 (items를 INVENTORY 테이블에 insert)
	        inboundService.insertInventory(req);
	        
	        // 상태 업데이트 (입고완료 → 재고등록완료)
	        inboundService.updateInboundStatusInboundComplete(req.getIbwaitIdx(), "재고등록완료");

	        return Map.of("ok", true, "ibwaitIdx", req.getIbwaitIdx());
	    } catch (Exception e) {
	        e.printStackTrace();
	        return Map.of("ok", false, "error", e.getMessage());
	    }
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

        // --- 엑셀 생성 ---
        Workbook workbook = excelExportService.createInboundManagementExcel(searchParams);

        // --- 응답 헤더 ---
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=inbound_management.xlsx");

        workbook.write(response.getOutputStream());
        workbook.close();
    }
	
	// 필터된 정보 조회
    @GetMapping("/management/data")
    @ResponseBody
    public Map<String, Object> getInboundData(
            @RequestParam Map<String, String> params,
            Authentication auth
    ) {
        EmployeeDetail emp = (EmployeeDetail) auth.getPrincipal();

        // --- 검색 조건 정리 ---
        Map<String, Object> searchParams = new HashMap<>(params);

        // 내 담당건만 보기
        if ("Y".equals(params.get("myOnly"))) {
            searchParams.put("manager", emp.getEmpName());
        }
        
        if (params.containsKey("managerKeyword") && params.get("managerKeyword") != null && !params.get("managerKeyword").isBlank()) {
            searchParams.put("managerKeyword", params.get("managerKeyword").trim());
        }

        // --- 페이징 처리 ---
        int pageSize = 10; // 한 페이지에 보여줄 건수
        int pageNum = Integer.parseInt(params.getOrDefault("pageNum", "1"));
        int startRow = (pageNum - 1) * pageSize;
        searchParams.put("pageSize", pageSize);
        searchParams.put("startRow", startRow);

        // --- 조회 ---
        List<InboundManagementDTO> list = inboundService.selectInboundListFilter(searchParams);
        int totalCount = inboundService.selectInboundCountFilter(searchParams);

        // --- 결과 반환 ---
        return Map.of(
                "list", list,
                "totalCount", totalCount,
                "pageInfo", makePageInfo(totalCount, pageNum, pageSize)
        );
    }

   
	//페이지 정보 생성 유틸
    private Map<String, Object> makePageInfo(int totalCount, int pageNum, int pageSize) {
        int maxPage = (int) Math.ceil((double) totalCount / pageSize);

        return Map.of(
                "pageNum", pageNum,
                "pageSize", pageSize,
                "maxPage", maxPage,
                "totalCount", totalCount,
                "startRow", (pageNum - 1) * pageSize
        );
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
	
	// test
	@GetMapping("/qrTest")
    public String qrTestPage() {
        return "/inbound/qrTest";
    }
}
