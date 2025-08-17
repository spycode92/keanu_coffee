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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.SystemPreferencesService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference")
public class SystemPreferencesController {
	private final SystemPreferencesService systemPreferencesService;
	

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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@GetMapping("")
	public String systemPreference(Model model) {
		List<DepartTeamRoleDTO> departmentList = systemPreferencesService.getDepartInfo();
		
		model.addAttribute("departmentList", departmentList);
		return "/admin/system_preferences";
	}
}
