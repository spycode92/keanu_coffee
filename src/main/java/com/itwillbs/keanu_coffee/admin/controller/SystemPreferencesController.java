package com.itwillbs.keanu_coffee.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.SystemPreferencesService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference")
public class SystemPreferencesController {
	private final SystemPreferencesService systemPreferencesService;
	
	// 조직관리
	// 부서 선택시 팀, 직책 목록 보여주기
	@GetMapping("/getTeamsAndRoles")
	@ResponseBody
	public ResponseEntity<Map<String, List<DepartTeamRoleDTO>>> getTeamsAndRoles(DepartTeamRoleDTO departTeamRoleDTO) {
		
		// 부서고유번호를 이용하여 팀, 직책 정보 불러오기
		List<DepartTeamRoleDTO> teamList = systemPreferencesService.getTeamsByDepartmentIdx(departTeamRoleDTO.getDepartmentIdx()); //departmentIdx
		List<DepartTeamRoleDTO> roleList = systemPreferencesService.getRolesByDepartmentIdx(departTeamRoleDTO.getDepartmentIdx()); //departmentIdx
		
		System.out.println(teamList);
		System.out.println(roleList);
		
		Map<String, List<DepartTeamRoleDTO>> result = new HashMap<>();
		
		result.put("teams", teamList);
	    result.put("roles", roleList);
		
		
		return ResponseEntity.ok(result);
	}
	
	//부서추가
	@PostMapping("/addDepartment")
	@ResponseBody
	public ResponseEntity<DepartTeamRoleDTO> addDepartment(@RequestBody DepartTeamRoleDTO DTRdto){
		
		DepartTeamRoleDTO saved = systemPreferencesService.addDepartment(DTRdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//팀추가
	@PostMapping("/addTeam")
	@ResponseBody
	public ResponseEntity<DepartTeamRoleDTO> addTeam(@RequestBody DepartTeamRoleDTO DTRdto){
		
		DepartTeamRoleDTO saved = systemPreferencesService.addTeam(DTRdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//직책추가
	@PostMapping("/addRole")
	@ResponseBody
	public ResponseEntity<DepartTeamRoleDTO> addRole(@RequestBody DepartTeamRoleDTO DTRdto){
		
		DepartTeamRoleDTO saved = systemPreferencesService.addRole(DTRdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//부서삭제
	@DeleteMapping("/removeDepartment")
	@ResponseBody
	public ResponseEntity<Void> removeDepartment(@RequestBody Map<String, Long> data) {
		Long departmentIdx = data.get("idx");
		boolean deleted = systemPreferencesService.removeDepartmentByIdx(departmentIdx);
		
		if (deleted) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	//팀삭제
	@DeleteMapping("/removeTeam")
	@ResponseBody
	public ResponseEntity<Void> deleteTeam(@RequestBody Map<String, Long> data) {
	    Long teamIdx = data.get("idx");
	    boolean deleted = systemPreferencesService.deleteTeamByIdx(teamIdx);
	    if (deleted) {
	        return ResponseEntity.ok().build();
	    } else {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	    }
	}
	
	//직책삭제
	@DeleteMapping("/removeRole")
	@ResponseBody
	public ResponseEntity<Void> deleteRole(@RequestBody Map<String, Long> data) {
		Long idx = data.get("idx");
		boolean deleted = systemPreferencesService.deleteRoleByIdx(idx);
		if (deleted) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	//부서이름수정
	@PutMapping("/modifyDepartment")
	@ResponseBody
	public ResponseEntity<Void> modifyDepartment(@RequestBody DepartTeamRoleDTO dto) {
	    boolean success = systemPreferencesService.modifyDepartmentName(dto.getIdx(), dto.getDepartmentName());
	    if (success) {
	        return ResponseEntity.ok().build();
	    } else {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	    }
	}
	
	//팀이름수정
	@PutMapping("/modifyTeam")
	@ResponseBody
	public ResponseEntity<Void> modifyTeam(@RequestBody DepartTeamRoleDTO dto) {
		boolean success = systemPreferencesService.modifyTeamName(dto.getIdx(), dto.getTeamName());
		if (success) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	//팀이름수정
	@PutMapping("/modifyRole")
	@ResponseBody
	public ResponseEntity<Void> modifyRole(@RequestBody DepartTeamRoleDTO dto) {
		boolean success = systemPreferencesService.modifyRoleName(dto.getIdx(), dto.getRoleName());
		if (success) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	// ----------------------------------------------------------------------------------------------
	// 공급계약관리
	// 공급업체등록
	@PostMapping("/addSupplier")
	@ResponseBody
	public SupplierProductContractDTO addSupplier(@RequestBody SupplierProductContractDTO supplierDto) {
	    // service로 저장, id/idx 반영된 저장 결과 반환
		SupplierProductContractDTO savedSupplier = systemPreferencesService.addSupplier(supplierDto);
		
	    // 바로 프론트로 등록된 객체 전달 (or 새로 조회하여 보낼수도 있음)
	    return savedSupplier;
	}
	
	//상태별공급업체필터링
	@GetMapping("/suppliers")
	@ResponseBody
	public List<SupplierProductContractDTO> getSuppliers(@RequestParam String status) {
        return systemPreferencesService.getSuppliersInfo();
	}
	
	// 공급업체삭제
	@DeleteMapping("/removeSupplier")
	@ResponseBody
	public ResponseEntity<?> removeSupplier(@RequestBody Map<String, Long> param) {
	    Long idx = param.get("idx");
	    boolean removed = systemPreferencesService.removeSupplierByIdx(idx);
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
	    return systemPreferencesService.selectSupplierByIdx(idx);
	}
	
	//공급업체정보수정
	@PutMapping("/modifySupplier")
	@ResponseBody
	public String modifySupplier(@RequestBody SupplierProductContractDTO supplier) {
	    int updateCount = systemPreferencesService.modifySupplier(supplier);
	    if (updateCount > 0) {
	        return "success";
	    } else {
	        return "fail";
	    }
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@GetMapping("")
	public String systemPreference(Model model) {
		// 부서리스트 가져오기
		List<DepartTeamRoleDTO> departmentList = systemPreferencesService.getDepartInfo();
		model.addAttribute("departmentList", departmentList);
		
		//공급처, 상품, 계약
		//공급처 리스트 가져오기
		List<SupplierProductContractDTO> supplierList = systemPreferencesService.getSuppliersInfo();
		model.addAttribute("supplierList",supplierList);
		
		//상품 리스트 가져오기
		List<SupplierProductContractDTO> productList = systemPreferencesService.getProductsInfo();
		model.addAttribute("productList",productList);
		
		//공급계약 리스트 가져오기
		List<SupplierProductContractDTO> supplyContractList = systemPreferencesService.getsupplyContractInfo();
		model.addAttribute("supplyContractList",supplyContractList);
		
		
		
		return "/admin/system_preferences";
	}
}
