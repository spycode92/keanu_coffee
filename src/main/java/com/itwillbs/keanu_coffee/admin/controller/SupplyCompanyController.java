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

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.OrganizationService;
import com.itwillbs.keanu_coffee.admin.service.SupplyCompanyService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/supplyCompany")
public class SupplyCompanyController {
	private final SupplyCompanyService supplyCompanyService;
	// 공급계약관리
	// 공급업체등록
	@PostMapping("/addSupplier")
	@ResponseBody
	public SupplierProductContractDTO addSupplier(@RequestBody SupplierProductContractDTO supplierDto) {
	    // service로 저장, id/idx 반영된 저장 결과 반환
		SupplierProductContractDTO savedSupplier = supplyCompanyService.addSupplier(supplierDto);
		
	    // 바로 프론트로 등록된 객체 전달 (or 새로 조회하여 보낼수도 있음)
	    return savedSupplier;
	}
	
	//상태별공급업체필터링
	@GetMapping("/suppliers")
	@ResponseBody
	public List<SupplierProductContractDTO> getSuppliers() {
        return supplyCompanyService.getSuppliersInfo();
	}
	
	// 공급업체삭제
	@DeleteMapping("/removeSupplier")
	@ResponseBody
	public ResponseEntity<?> removeSupplier(@RequestBody Map<String, Long> param) {
	    Long idx = param.get("idx");
	    boolean removed = supplyCompanyService.removeSupplierByIdx(idx);
	    if(removed) {
	        return ResponseEntity.ok().body("삭제되었습니다");
	    } else {
	        return ResponseEntity.status(HttpStatus.CONFLICT).body("삭제 불가능합니다. 계약이 남아있는지 확인하십시오.");
	    }
	}
	
	//공급업체상세보기
	@GetMapping("/supplier/{idx}")
	@ResponseBody
	public SupplierProductContractDTO getSupplierDetail(@PathVariable Long idx) {
	    return supplyCompanyService.selectSupplierByIdx(idx);
	}
	
	//공급업체정보수정
	@PutMapping("/modifySupplier")
	@ResponseBody
	public String modifySupplier(@RequestBody SupplierProductContractDTO supplier) {
	    int updateCount = supplyCompanyService.modifySupplier(supplier);
	    if (updateCount > 0) {
	        return "success";
	    } else {
	        return "fail";
	    }
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@GetMapping("")
	public String systemPreference(Model model) {
		
		//공급처 리스트 가져오기
		List<SupplierProductContractDTO> supplierList = supplyCompanyService.getSuppliersInfo();
		model.addAttribute("supplierList",supplierList);
		
		
		
		
		return "/admin/system_preference/supply_company_management";
	}
}
