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

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/dept")
public class OrganizationController {
	private final OrganizationService organizationService;
	
	@GetMapping("")
	public String systemPreference(Model model) {
		// 부서리스트 가져오기
		List<DepartTeamRoleDTO> departmentList = organizationService.getDepartInfo();
		model.addAttribute("departmentList", departmentList);
		
		return "/admin/system_preference/organization_management";
	}
	
	// 조직관리
	// 부서 선택시 팀, 직책 목록 보여주기
	@GetMapping("/getTeamsAndRoles")
	@ResponseBody
	public ResponseEntity<Map<String, List<DepartTeamRoleDTO>>> getTeamsAndRoles(DepartTeamRoleDTO departTeamRoleDTO) {
		
		// 부서고유번호를 이용하여 팀, 직책 정보 불러오기
		List<DepartTeamRoleDTO> teamList = organizationService.getTeamsByDepartmentIdx(departTeamRoleDTO.getDepartmentIdx()); //departmentIdx
		List<DepartTeamRoleDTO> roleList = organizationService.getRolesByDepartmentIdx(departTeamRoleDTO.getDepartmentIdx()); //departmentIdx
		
		Map<String, List<DepartTeamRoleDTO>> result = new HashMap<>();
		
		result.put("teams", teamList);
	    result.put("roles", roleList);
		
		return ResponseEntity.ok(result);
	}
	
	//부서추가
	@PostMapping("/addDepartment")
	@ResponseBody
	public ResponseEntity<DepartTeamRoleDTO> addDepartment(@RequestBody DepartTeamRoleDTO DTRdto){
		
		DepartTeamRoleDTO saved = organizationService.addDepartment(DTRdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//팀추가
	@PostMapping("/addTeam")
	@ResponseBody
	public ResponseEntity<DepartTeamRoleDTO> addTeam(@RequestBody DepartTeamRoleDTO DTRdto){
		
		DepartTeamRoleDTO saved = organizationService.addTeam(DTRdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//직책추가
	@PostMapping("/addRole")
	@ResponseBody
	public ResponseEntity<DepartTeamRoleDTO> addRole(@RequestBody DepartTeamRoleDTO DTRdto){
		
		DepartTeamRoleDTO saved = organizationService.addRole(DTRdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//부서삭제
	@DeleteMapping("/removeDepartment")
	@ResponseBody
	public ResponseEntity<Void> removeDepartment(@RequestBody Map<String, Long> data) {
		Long departmentIdx = data.get("idx");
		boolean deleted = organizationService.removeDepartmentByIdx(departmentIdx);
		
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
	    boolean deleted = organizationService.deleteTeamByIdx(teamIdx);
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
		boolean deleted = organizationService.deleteRoleByIdx(idx);
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
	    boolean success = organizationService.modifyDepartmentName(dto.getIdx(), dto.getDepartmentName());
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
		boolean success = organizationService.modifyTeamName(dto.getIdx(), dto.getTeamName());
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
		boolean success = organizationService.modifyRoleName(dto.getIdx(), dto.getRoleName());
		if (success) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	

}
