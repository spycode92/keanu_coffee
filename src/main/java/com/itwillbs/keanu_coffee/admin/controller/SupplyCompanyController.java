package com.itwillbs.keanu_coffee.admin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.OrganizationService;
import com.itwillbs.keanu_coffee.admin.service.SupplyCompanyService;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/supplyCompany")
public class SupplyCompanyController {
	private final SupplyCompanyService supplyCompanyService;

	// 공급업체관리 목록조회
	@GetMapping("")
	public String systemPreference(Model model, @RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchType, @RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "") String orderKey, @RequestParam(defaultValue = "") String orderMethod) {
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("sortKey", orderKey);
		model.addAttribute("sortMethod", orderMethod);
		// 한페이지보여줄수
		int listLimit = 10;
		// 조회된 목록수
		int supplierCount = supplyCompanyService.getSupplierCount(searchType, searchKeyword);
		// 조회된 목록이 1개이상일때
		if (supplierCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, supplierCount, pageNum, 3);

			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/systemPreference/supplyCompany");
				return "commons/result_process";
			}

			model.addAttribute("pageInfo", pageInfoDTO);

			List<SupplierDTO> supplierList = supplyCompanyService.getSuppliersInfo(pageInfoDTO.getStartRow(), listLimit,
					searchType, searchKeyword, orderKey, orderMethod);
			model.addAttribute("supplierList", supplierList);
		}

		return "/admin/system_preference/supply_company_management";
	}

	// 공급계약관리
	// 공급업체등록
	@PostMapping("/addSupplier")
	@ResponseBody
	public SupplierDTO addSupplier(@RequestBody SupplierDTO supplierDto) {
		// service로 저장, id/idx 반영된 저장 결과 반환
		SupplierDTO savedSupplier = supplyCompanyService.addSupplier(supplierDto);

		// 바로 프론트로 등록된 객체 전달 (or 새로 조회하여 보낼수도 있음)
		return savedSupplier;
	}

	// 공급업체상세보기
	@GetMapping("/supplier/{idx}")
	@ResponseBody
	public SupplierDTO getSupplierDetail(@PathVariable Long idx) {
		return supplyCompanyService.selectSupplierByIdx(idx);
	}

	// 공급업체정보수정
	@PostMapping("/modifySupplier")
	@ResponseBody
	public String modifySupplier(@RequestBody SupplierDTO supplier) {

		int updateCount = supplyCompanyService.modifySupplier(supplier);
		if (updateCount > 0) {
			return new Gson().toJson("success");
		} else {
			return new Gson().toJson("fail");
		}
	}

	// 공급처삭제
	@PostMapping("/removeSupplier")
	@ResponseBody
	public ResponseEntity<Map<String, String>> removeSuppleir(@RequestBody SupplierDTO supplier) {
		Map<String, String> res = new HashMap();
		supplier = supplyCompanyService.selectSupplierByIdx((long) supplier.getSupplierIdx());

		boolean result = supplyCompanyService.deleteSupplier(supplier);

		if (result) {
			res.put("result", "success");
			res.put("msg", "상품정보가 수정되었습니다");
			return ResponseEntity.ok(res);
		}
		res.put("result", "error");
		res.put("msg", "잠시후 다시시도 하십시오.<br>등록된 계약이 없나 확인하십시오. ");
		return ResponseEntity.ok(res);
	}

	// 공급처목록 조회 AJAX
	@GetMapping("/suppliers")
	@ResponseBody
	public List<SupplierDTO> getSupplierList() {

		List<SupplierDTO> supplierList = supplyCompanyService.getSupplierList();

		return supplierList;

	}

}
