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
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.OrganizationService;
import com.itwillbs.keanu_coffee.admin.service.SupplyContractService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/supplyContract")
public class SupplyContractController {
	private final SupplyContractService supplyContractService;
	
    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    // 공급계약
    @GetMapping("/getContractList")
    @ResponseBody
    public List<SupplierProductContractDTO> getContractList() {
		//공급계약 리스트 가져오기
		List<SupplierProductContractDTO> supplyContractList = supplyContractService.getsupplyContractInfo();

    	return supplyContractList;
    }
    
    //공급계약등록
    @PostMapping("/addContract")
    @ResponseBody
    public SupplierProductContractDTO addContract(SupplierProductContractDTO supplyContract) {
    	
    	boolean result = supplyContractService.addContract(supplyContract);
    	
    	return supplyContract;
    }
	
    // 공급계약상세정보
    @GetMapping("/getContractDetail")
    @ResponseBody
    public SupplierProductContractDTO getContractDetail(SupplierProductContractDTO supplyContract) {
    	SupplierProductContractDTO contractDetail = supplyContractService.getContractDetail(supplyContract);
    	return contractDetail;
    }
    
    //공급계약수정
    @PostMapping("/updateContractDetail")
    @ResponseBody
    public SupplierProductContractDTO updateContractDetail(@RequestBody SupplierProductContractDTO contract) {
    	SupplierProductContractDTO saved = supplyContractService.updateContractDetail(contract);
    	
    	return contract;
    }
    
    //공급계약삭제
    @PostMapping("/deleteContractDetail")
    @ResponseBody
    public ResponseEntity<Map<String,String>> deleteContractDetail(@RequestBody SupplierProductContractDTO contract) {
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	@GetMapping("")
	public String systemPreference(Model model) {
		
		
		return "/admin/system_preference/supply_contract_management";
	}
}
