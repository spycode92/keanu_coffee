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
import com.itwillbs.keanu_coffee.admin.dto.RoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.dto.TeamDTO;
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
		List<DepartmentDTO> departmentList = organizationService.getDepartInfo();
		model.addAttribute("departmentList", departmentList);
		
		return "/admin/system_preference/organization_management";
	}
	
	// 조직관리
	// 부서 선택시 팀, 직책 목록 보여주기
	@GetMapping("/getTeamsAndRoles")
	@ResponseBody
	public ResponseEntity<Map<String, List>> getTeamsAndRoles(DepartmentDTO departmentDTO) {
		Integer departmentIdx = departmentDTO.getDepartmentIdx();
		
		// 부서고유번호를 이용하여 팀, 직책 정보 불러오기
		List<TeamDTO> teamList = organizationService.getTeamsByDepartmentIdx(departmentIdx); //departmentIdx
		List<RoleDTO> roleList = organizationService.getRolesByDepartmentIdx(departmentIdx); //departmentIdx
		
		Map<String, List> result = new HashMap<>();
		
		result.put("teams", teamList);
	    result.put("roles", roleList);
		
		return ResponseEntity.ok(result);
	}
	
	//부서추가
	@PostMapping("/addDepartment")
	@ResponseBody
	public ResponseEntity<DepartmentDTO> addDepartment(@RequestBody DepartmentDTO DTRdto){
		
		DepartmentDTO saved = organizationService.addDepartment(DTRdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//팀추가
	@PostMapping("/addTeam")
	@ResponseBody
	public ResponseEntity<TeamDTO> addTeam(@RequestBody TeamDTO Teamdto){
		
		TeamDTO saved = organizationService.addTeam(Teamdto);
		
		return ResponseEntity.ok(saved);
	}
	
	//직책추가
	@PostMapping("/addRole")
	@ResponseBody
	public ResponseEntity<RoleDTO> addRole(@RequestBody RoleDTO roleDTO){
		
		RoleDTO saved = organizationService.addRole(roleDTO);
		
		return ResponseEntity.ok(saved);
	}
	
	//부서삭제
	@DeleteMapping("/removeDepartment")
	@ResponseBody
	public ResponseEntity<Void> removeDepartment(@RequestBody Map<String, Long> data) {
		Long departmentIdx = data.get("deparmentidx");
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
	public ResponseEntity<Void> deleteTeam(@RequestBody Map<String, Integer> data) {
		Integer teamIdx = data.get("idx");
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
	public ResponseEntity<Void> deleteRole(@RequestBody Map<String, Integer> data) {
		Integer roleIdx = data.get("idx");
		boolean deleted = organizationService.deleteRoleByIdx(roleIdx);
		if (deleted) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	//부서이름수정
	@PutMapping("/modifyDepartment")
	@ResponseBody
	public ResponseEntity<Void> modifyDepartment(@RequestBody DepartmentDTO dto) {
	    boolean success = organizationService.modifyDepartmentName(dto.getDepartmentIdx(), dto.getDepartmentName());
	    if (success) {
	        return ResponseEntity.ok().build();
	    } else {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	    }
	}
	
	//팀이름수정
	@PutMapping("/modifyTeam")
	@ResponseBody
	public ResponseEntity<Void> modifyTeam(@RequestBody TeamDTO teamDTO) {
		boolean success = organizationService.modifyTeamName(teamDTO.getTeamIdx(), teamDTO.getTeamName());
		if (success) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	//팀이름수정
	@PutMapping("/modifyRole")
	@ResponseBody
	public ResponseEntity<Void> modifyRole(@RequestBody RoleDTO roleDTO) {
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println(roleDTO);
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		boolean success = organizationService.modifyRoleName(roleDTO.getRoleIdx(), roleDTO.getRoleName());
		if (success) {
			return ResponseEntity.ok().build();
		} else {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	

}
