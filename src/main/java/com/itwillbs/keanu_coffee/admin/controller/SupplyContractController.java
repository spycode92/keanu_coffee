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

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplyContractDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.OrganizationService;
import com.itwillbs.keanu_coffee.admin.service.SupplyContractService;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/supplyContract")
public class SupplyContractController {
	private final SupplyContractService supplyContractService;
	
    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    // 공급계약목록
	@GetMapping("")
	public String systemPreference(Model model, @RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue ="") String orderKey,
			@RequestParam(defaultValue ="") String orderMethod,
			@RequestParam(defaultValue ="") String filterStatus) {
		model.addAttribute("pageNum",pageNum);
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchKeyword",searchKeyword);
		model.addAttribute("orderKey",orderKey);
		model.addAttribute("orderMethod",orderMethod);
		model.addAttribute("filterStatus",filterStatus);
		int listLimit = 10;
		int contractListCount = supplyContractService.getContractListCount(searchType, searchKeyword, filterStatus);
		
		if (contractListCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, contractListCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/customer/notice_list");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
		
			List<SupplyContractDTO> supplyContractList = supplyContractService.getsupplyContractInfo(
					pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword, orderKey, orderMethod, filterStatus);
			model.addAttribute("supplyCotractList", supplyContractList);
		}
		
		
		
		return "/admin/system_preference/supply_contract_management";
	}
	
//    @GetMapping("/getContractList")
//    @ResponseBody
//    public List<SupplyContractDTO> getContractList() {
//		//공급계약 리스트 가져오기
//		List<SupplyContractDTO> supplyContractList = supplyContractService.getsupplyContractInfo();
//
//    	return supplyContractList;
//    }
    
    //공급계약등록
    @PostMapping("/addContract")
    @ResponseBody
    public SupplyContractDTO addContract(SupplyContractDTO supplyContract) {
    	
    	boolean result = supplyContractService.addContract(supplyContract);
    	
    	return supplyContract;
    }
	
    // 공급계약상세정보
    @GetMapping("/getContractDetail")
    @ResponseBody
    public SupplyContractDTO getContractDetail(SupplyContractDTO supplyContract) {
    	SupplyContractDTO contractDetail = supplyContractService.getContractDetail(supplyContract);
    	return contractDetail;
    }
    
    //공급계약수정
    @PostMapping("/updateContractDetail")
    @ResponseBody
    public SupplyContractDTO updateContractDetail(@RequestBody SupplyContractDTO contract) {
    	SupplyContractDTO saved = supplyContractService.updateContractDetail(contract);
    	
    	return contract;
    }
    
    //공급계약삭제
    @PostMapping("/deleteContractDetail")
    @ResponseBody
    public ResponseEntity<Map<String,String>> deleteContractDetail(@RequestBody SupplyContractDTO contract) {
    	boolean result = supplyContractService.deleteContractDetail(contract);
    	Map<String,String> response = new HashMap<>();
        if (result) {
            response.put("status", "success");
            return ResponseEntity.ok(response);
        } else {
            response.put("status", "fail");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    
    }
	

}
