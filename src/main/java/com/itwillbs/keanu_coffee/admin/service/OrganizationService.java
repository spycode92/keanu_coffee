package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.OrganizationMapper;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OrganizationService {
	
	private final OrganizationMapper organizationMapper;
	private final EmployeeManagementMapper employeeManagementMapper;
	private final HttpSession session;
	private final FileMapper fileMapper;
	
	
	//부서 전체 목록 받아오기
	public List<DepartTeamRoleDTO> getDepartInfo() {
		return organizationMapper.getDepartmentInfo();
	}
	
	//해당 부서의 팀 목록 받아오기
	public List<DepartTeamRoleDTO> getTeamsByDepartmentIdx(int departmentIdx) {

		return organizationMapper.getTeamsInfoByDepartmentIdx(departmentIdx);
	}
	
	//해당 부서의 직책목록 받아오기
	public List<DepartTeamRoleDTO> getRolesByDepartmentIdx(int departmentIdx) {
		return organizationMapper.getRolesInfoByDepartmentIdx(departmentIdx);
	}
	
	//부서추가
	public DepartTeamRoleDTO addDepartment(DepartTeamRoleDTO departTeamRoleDTO) {
		organizationMapper.insertDepartment(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//팀 추가
	public DepartTeamRoleDTO addTeam(DepartTeamRoleDTO departTeamRoleDTO) {
		organizationMapper.insertTeam(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//직책추가
	public DepartTeamRoleDTO addRole(DepartTeamRoleDTO departTeamRoleDTO) {
		organizationMapper.insertRole(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//부서삭제
	@Transactional
	public boolean removeDepartmentByIdx(Long departmentIdx) {
		// 해당 부서의 팀,직책 모두 NULL처리
		employeeManagementMapper.updateDeptTeamRoleToNull(departmentIdx);
		
		//해당 부서에 속해있는 팀목록, 팀수
		List<DepartTeamRoleDTO> departTeamDTOList 
			= organizationMapper.departTeamList(departmentIdx);
		
		for (DepartTeamRoleDTO dto : departTeamDTOList) {
			deleteTeamByIdx((long)dto.getIdx());
		}
		
		//해당 부서에 속해있는 직책 목록
		List<DepartTeamRoleDTO> departRoleDTOList 
			= organizationMapper.departRoleList(departmentIdx);
		
		for (DepartTeamRoleDTO dto : departRoleDTOList) {
			deleteRoleByIdx((long)dto.getIdx());
		}
		
		int deletedDept =organizationMapper.deleteDepartment(departmentIdx);
		
		return deletedDept == 1;
	}
	
	// 팀 삭제
	@Transactional
	public boolean deleteTeamByIdx(Long teamIdx) {
		// 직원정보 테이블의 팀 널로 바꾸기
		employeeManagementMapper.updateTeamToNull(teamIdx);
		
		//팀 삭제
		int deletedTeam = organizationMapper.deleteTeam(teamIdx);
	    return deletedTeam == 1;
	}
	
	// 직책삭제
	@Transactional
	public boolean deleteRoleByIdx(Long roleIdx) {
		// 중간테이블 게시판,권한,직책 테이블의 내용삭제
		organizationMapper.deleteRoleMenuAuthoByRoleIdx(roleIdx);
		
		// 직원정보 테이블의 roleIdx를 Null 값 또는 기본값 처리
		employeeManagementMapper.updateRoleToNull(roleIdx);
		
		// 직책삭제
		int affectedRows = organizationMapper.deleteRole(roleIdx);
		return affectedRows == 1;
	}
	
	//부서 이름수정
	public boolean modifyDepartmentName(int idx, String departmentName) {
		int affectedRows = organizationMapper.updateDepartment(idx, departmentName);
		
		return  affectedRows == 1;
	}

	//팀이름수정
	public boolean modifyTeamName(int idx, String teamName) {
		int affectedRows = organizationMapper.updateTeam(idx, teamName);
		
		return  affectedRows == 1;
	}
	// 직책이름 수정
	public boolean modifyRoleName(int idx, String roleName) {
		int affectedRows = organizationMapper.updateRole(idx, roleName);
		
		return  affectedRows == 1;
	}
	
	
}
