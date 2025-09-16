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
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.dto.TeamDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.OrganizationService;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

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

		// 권한정보 가져오기
		List<CommonCodeDTO> authorityList = organizationService.getAuthorityList();

		model.addAttribute("authorityList", authorityList);
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
		List<TeamDTO> teamList = organizationService.getTeamsByDepartmentIdx(departmentIdx); // departmentIdx
		List<RoleDTO> roleList = organizationService.getRolesByDepartmentIdx(departmentIdx); // departmentIdx

		Map<String, List> result = new HashMap<>();

		result.put("teams", teamList);
		result.put("roles", roleList);

		return ResponseEntity.ok(result);
	}

	// 부서추가
	@PostMapping("/addDepartment")
	@ResponseBody
	public ResponseEntity<DepartmentDTO> addDepartment(@RequestBody DepartmentDTO DTRdto) {

		DepartmentDTO saved = organizationService.addDepartment(DTRdto);

		return ResponseEntity.ok(saved);
	}

	// 팀추가
	@PostMapping("/addTeam")
	@ResponseBody
	public ResponseEntity<TeamDTO> addTeam(@RequestBody TeamDTO Teamdto) {

		TeamDTO saved = organizationService.addTeam(Teamdto);

		return ResponseEntity.ok(saved);
	}

	// 직책추가
	@PostMapping("/addRole")
	@ResponseBody
	public ResponseEntity<RoleDTO> addRole(@RequestBody RoleDTO roleDTO) {
		RoleDTO saved = organizationService.addRole(roleDTO);
		return ResponseEntity.ok(saved);
	}

	// 부서삭제
	@PostMapping("/removeDepartment")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> removeDepartment(@RequestBody Map<String, Integer> data) {
		Integer departmentIdx = data.get("departmentIdx");
		CommonCodeDTO commonCodeDTO = organizationService.selectDept(departmentIdx);
		boolean deleted = organizationService.removeDepartmentByIdx(departmentIdx, commonCodeDTO.getCommonCodeName());

		Map<String, Object> response = new HashMap<>();

		if (deleted) {
			response.put("success", true);
			response.put("message", "부서가 성공적으로 삭제되었습니다.");
			return ResponseEntity.ok(response);
		} else {
			response.put("success", false);
			response.put("message", "부서 삭제에 실패했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 팀삭제
	@PostMapping("/removeTeam")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteTeam(@RequestBody Map<String, Integer> data) {
		Integer teamIdx = data.get("teamIdx");
		TeamDTO team = organizationService.selectTeam(teamIdx);

		boolean deleted = organizationService.deleteTeamByIdx(teamIdx, team.getTeamName());

		Map<String, Object> response = new HashMap<>();

		if (deleted) {
			response.put("success", true);
			response.put("message", "팀이 성공적으로 삭제되었습니다.");
			return ResponseEntity.ok(response);
		} else {
			response.put("success", false);
			response.put("message", "팀 삭제에 실패했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 직책삭제
	@PostMapping("/removeRole")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteRole(@RequestBody Map<String, Integer> data) {
		Integer roleIdx = data.get("roleIdx");
		RoleDTO role = organizationService.selectRole(roleIdx);
		boolean deleted = organizationService.deleteRoleByIdx(roleIdx, (String) role.getRoleName());

		Map<String, Object> response = new HashMap<>();

		if (deleted) {
			response.put("success", true);
			response.put("message", "직책이 성공적으로 삭제되었습니다.");
			return ResponseEntity.ok(response);
		} else {
			response.put("success", false);
			response.put("message", "직책 삭제에 실패했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 부서이름수정
	@PostMapping("/modifyDepartment")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> modifyDepartment(@RequestBody DepartmentDTO dto) {
		boolean success = organizationService.modifyDepartmentName(dto.getDepartmentIdx(), dto.getDepartmentName());
		Map<String, Object> response = new HashMap<>();
		if (success) {
			response.put("success", true);
			response.put("message", "부서명이 성공적으로 수정되었습니다.");
			response.put("data", dto);
			return ResponseEntity.ok(response);
		} else {
			response.put("success", false);
			response.put("message", "부서명 수정에 실패했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 팀이름수정
	@PostMapping("/modifyTeam")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> modifyTeam(@RequestBody TeamDTO teamDTO) {
		boolean success = organizationService.modifyTeamName(teamDTO.getTeamIdx(), teamDTO.getTeamName());
		Map<String, Object> response = new HashMap<>();
		if (success) {
			response.put("success", true);
			response.put("message", "팀이름 수정에 성공하였습니다.");
			response.put("data", teamDTO);
			return ResponseEntity.ok(response);
		} else {
			response.put("success", false);
			response.put("message", "팀이름 수정에 실패했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 직책이름수정
	@PostMapping("/modifyRole")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> modifyRole(@RequestBody RoleDTO roleDTO) {
		boolean success = organizationService.modifyRoleName(roleDTO.getRoleIdx(), roleDTO.getRoleName());
		Map<String, Object> response = new HashMap<>();
		if (success) {
			response.put("success", true);
			response.put("message", "직책이름 수정에 성공하였습니다.");
			response.put("data", roleDTO);
			return ResponseEntity.ok(response);
		} else {
			response.put("success", false);
			response.put("message", "직책이름 수정에 실패했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 직책에부여된 권한정보가져오기
	@GetMapping("/getAutho")
	public ResponseEntity<List<Map<String, Object>>> getRolesAutho(@RequestParam Integer roleIdx) {
		List<Map<String, Object>> authority = organizationService.getAuthrityInfo(roleIdx);

		return ResponseEntity.ok(authority);
	}

	// 직책에 변경된 권한 정보 저장하기
	@PostMapping("/saveRoleAutho")
	@ResponseBody
	public ResponseEntity<Map<String, String>> modifyRoleAutho(@RequestBody Map<String, Object> data) {
		organizationService.modifyRoleAutho(data);
		Map<String, String> result = new HashMap<>();
		result.put("result", "success");
		result.put("msg", "권한정보 변경 완료");
		return ResponseEntity.ok(result);

	}

	// 권한 이름 변경
	@PostMapping("/modifyAutho")
	@ResponseBody
	public ResponseEntity<Map<String, String>> modifyAuthoName(@RequestBody Map<String, Object> data) {

		Map<String, String> result = new HashMap<>();
		Boolean modifyResult = organizationService.modifyAuthoName(data);
		if (modifyResult) {
			result.put("result", "success");
			result.put("msg", "직책이름 변경 완료");

			return ResponseEntity.ok(result);
		}
		result.put("result", "fail");
		result.put("msg", "직책이름 변경 실패");

		return ResponseEntity.ok(result);
	}

	// 권한 제거
	@PostMapping("/removeAutho/{authoIdx}")
	@ResponseBody
	public ResponseEntity<Map<String, String>> removeAuthoName(@PathVariable Integer authoIdx) {

		Map<String, String> result = new HashMap<>();
		CommonCodeDTO common = new CommonCodeDTO();
		common.setCommonCodeIdx(authoIdx);
		common = organizationService.selectAuthoName(common);

		result = organizationService.removeAuthoName(common);

		return ResponseEntity.ok(result);
	}

	// 권한 추가
	@PostMapping("/addAutho")
	@ResponseBody
	public ResponseEntity<Map<String, String>> addAutho(@RequestBody Map<String, Object> data) {

		Map<String, String> result = new HashMap<>();
		String authoCode = (String) data.get("authoCode");
		String authoName = (String) data.get("authoName");
		CommonCodeDTO common = new CommonCodeDTO();
		common.setCommonCode(authoCode);
		common.setCommonCodeName(authoName);

		result = organizationService.addAutho(common);

		return ResponseEntity.ok(result);
	}

}
