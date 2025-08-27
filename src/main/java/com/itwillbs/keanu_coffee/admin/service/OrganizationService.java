package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.management.relation.Role;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.RoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.dto.TeamDTO;
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
	public List<DepartmentDTO> getDepartInfo() {
		return organizationMapper.getDepartmentInfo();
	}
	
	//해당 부서의 팀 목록 받아오기
	public List<TeamDTO> getTeamsByDepartmentIdx(int departmentIdx) {

		return organizationMapper.getTeamsInfoByDepartmentIdx(departmentIdx);
	}
	
	//해당 부서의 직책목록 받아오기
	public List<RoleDTO> getRolesByDepartmentIdx(int departmentIdx) {
		return organizationMapper.getRolesInfoByDepartmentIdx(departmentIdx);
	}
	
	//부서추가
	public DepartmentDTO addDepartment(DepartmentDTO departTeamRoleDTO) {
		organizationMapper.insertDepartment(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//팀 추가
	public TeamDTO addTeam(TeamDTO teamdto) {
		organizationMapper.insertTeam(teamdto);
		return teamdto;
	}
	
	//직책추가
	public RoleDTO addRole(RoleDTO roleDTO) {
		organizationMapper.insertRole(roleDTO);
		return roleDTO;
	}
	
	//부서삭제
	@Transactional
	public boolean removeDepartmentByIdx(Integer departmentIdx) {
		// 해당 부서의 팀,직책 모두 NULL처리
		employeeManagementMapper.updateDeptTeamRoleToNull(departmentIdx);
		
		//해당 부서에 속해있는 팀목록, 팀수
		List<TeamDTO> TeamDTOList 
			= organizationMapper.departTeamList(departmentIdx);
		
		for (TeamDTO teamDTO : TeamDTOList) {
			deleteTeamByIdx((Integer)teamDTO.getTeamIdx());
		}
		
		//해당 부서에 속해있는 직책 목록
		List<RoleDTO> RoleDTOList 
			= organizationMapper.departRoleList(departmentIdx);
		
		for (RoleDTO roleDTO : RoleDTOList) {
			deleteRoleByIdx(roleDTO.getRoleIdx());
		}
		
		int deletedDept =organizationMapper.deleteDepartment(departmentIdx);
		
		return deletedDept == 1;
	}
	
	// 팀 삭제
	@Transactional
	public boolean deleteTeamByIdx(Integer teamIdx) {
		// 직원정보 테이블의 팀 널로 바꾸기
		employeeManagementMapper.updateTeamToNull(teamIdx);
		
		//팀 삭제
		int deletedTeam = organizationMapper.deleteTeam(teamIdx);
	    return deletedTeam == 1;
	}
	
	// 직책삭제
	@Transactional
	public boolean deleteRoleByIdx(Integer roleIdx) {
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
