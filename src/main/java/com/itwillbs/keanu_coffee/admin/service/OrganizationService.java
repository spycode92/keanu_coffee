package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.management.relation.Role;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.RoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.dto.TeamDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.OrganizationMapper;
import com.itwillbs.keanu_coffee.common.aop.annotation.SystemLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.SystemLogTarget;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
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
	@Transactional(readOnly = true)
	public List<DepartmentDTO> getDepartInfo() {
		return organizationMapper.getDepartmentInfo();
	}
	
	//해당 부서의 팀 목록 받아오기
	@Transactional(readOnly = true)
	public List<TeamDTO> getTeamsByDepartmentIdx(int departmentIdx) {

		return organizationMapper.getTeamsInfoByDepartmentIdx(departmentIdx);
	}
	
	//해당 부서의 직무목록 받아오기
	@Transactional(readOnly = true)
	public List<RoleDTO> getRolesByDepartmentIdx(int departmentIdx) {
		return organizationMapper.getRolesInfoByDepartmentIdx(departmentIdx);
	}
	
	//부서추가
	@SystemLog(target = SystemLogTarget.COMMON_CODE)
	public DepartmentDTO addDepartment(DepartmentDTO departTeamRoleDTO) {
		organizationMapper.insertDepartment(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//팀 추가
	@SystemLog(target = SystemLogTarget.TEAM)
	public TeamDTO addTeam(TeamDTO teamdto) {
		organizationMapper.insertTeam(teamdto);
		return teamdto;
	}
	
	//직무추가
	@SystemLog(target = SystemLogTarget.ROLE)
	public RoleDTO addRole(RoleDTO roleDTO) {
		organizationMapper.insertRole(roleDTO);
		return roleDTO;
	}
	
	//부서삭제
	@Transactional
	@SystemLog(target = SystemLogTarget.COMMON_CODE)
	public boolean removeDepartmentByIdx(Integer departmentIdx, String departmentName) {
		// 해당 부서의 팀,직무 모두 NULL처리
		employeeManagementMapper.updateDeptTeamRoleToNull(departmentIdx);
		
		//해당 부서에 속해있는 팀목록, 팀수
		List<TeamDTO> TeamDTOList 
			= organizationMapper.departTeamList(departmentIdx);
		
		for (TeamDTO teamDTO : TeamDTOList) {
			deleteTeamByIdx((Integer)teamDTO.getTeamIdx(), (String)teamDTO.getTeamName());
		}
		
		//해당 부서에 속해있는 직무 목록
		List<RoleDTO> RoleDTOList 
			= organizationMapper.departRoleList(departmentIdx);
		
		for (RoleDTO roleDTO : RoleDTOList) {
			deleteRoleByIdx(roleDTO.getRoleIdx(), roleDTO.getRoleName());
		}
		
		int deletedDept =organizationMapper.deleteDepartment(departmentIdx);
		
		return deletedDept == 1;
	}
	
	// 팀 삭제
	@Transactional
	@SystemLog(target = SystemLogTarget.TEAM)
	public boolean deleteTeamByIdx(Integer teamIdx, String teamName) {
		// 직원정보 테이블의 팀 널로 바꾸기
		employeeManagementMapper.updateTeamToNull(teamIdx);
		
		//팀 삭제
		int deletedTeam = organizationMapper.deleteTeam(teamIdx);
	    
		return deletedTeam == 1;
	}
	
	// 직무삭제
	@Transactional
	@SystemLog(target = SystemLogTarget.ROLE)
	public boolean deleteRoleByIdx(Integer roleIdx, String roleName) {
		// 중간테이블 게시판,권한,직무 테이블의 내용삭제
		organizationMapper.deleteRoleMenuAuthoByRoleIdx(roleIdx);
		
		// 직원정보 테이블의 roleIdx를 Null 값 또는 기본값 처리
		employeeManagementMapper.updateRoleToNull(roleIdx);
		
		// 직무삭제
		int affectedRows = organizationMapper.deleteRole(roleIdx);
		
		return affectedRows == 1;
	}
	
	//부서 이름수정
	@SystemLog(target = SystemLogTarget.COMMON_CODE)
	public boolean modifyDepartmentName(int idx, String departmentName) {
		
		int affectedRows = organizationMapper.updateDepartment(idx, departmentName);
		
		return  affectedRows == 1;
	}

	//팀이름수정
	@SystemLog(target = SystemLogTarget.TEAM)
	public boolean modifyTeamName(int idx, String teamName) {
		
		int affectedRows = organizationMapper.updateTeam(idx, teamName);
		
		return  affectedRows == 1;
	}
	
	// 직무이름 수정
	@SystemLog(target = SystemLogTarget.ROLE)
	public boolean modifyRoleName(int idx, String roleName) {
		int affectedRows = organizationMapper.updateRole(idx, roleName);
		
		return  affectedRows == 1;
	}
	
	//권한목록 가져오기
	@Transactional(readOnly = true)
	public List<CommonCodeDTO> getAuthorityList() {
		
		return organizationMapper.selectAuthorityList();
	}
	
	//직무별 권한정보 가져오기
	@Transactional(readOnly = true)
	public List<Map<String, Object>> getAuthrityInfo(Integer roleIdx) {
		
		return organizationMapper.selectAuthorityInfo(roleIdx);
	}
	
	//직무별 권한 업데이트
	@Transactional
	@SystemLog(target = SystemLogTarget.ROLE_AUTHO )
	public void modifyRoleAutho(Map<String, Object> data) throws Exception {
		
		Integer roleIdx = (Integer) data.get("roleIdx");
	   
		List<Integer> addedAuthorities = (List<Integer>) data.get("addedAuthorities");
	    List<Integer> removedAuthorities = (List<Integer>) data.get("removedAuthorities");
	    
	    try {
            if (!removedAuthorities.isEmpty()) {
                organizationMapper.deleteAuthorities(roleIdx, removedAuthorities);
            }
            
            if (!addedAuthorities.isEmpty()) {
            	organizationMapper.insertAuthorities(roleIdx, addedAuthorities);
            }
        } catch (Exception e) {
            throw new RuntimeException("권한 수정 실패: " + e.getMessage(), e);
        }
		
	}
	//권한이름수정
	@SystemLog(target = SystemLogTarget.COMMON_CODE)
	public Boolean modifyAuthoName(Map<String, Object> data) {
		
		Integer authoIdx = (Integer)data.get("authoIdx");
		String authoName = (String)data.get("authoName");
		
		int updateCount = organizationMapper.updateAuthoName(authoIdx, authoName);
		
		return updateCount > 0;
	}

	//권한삭제
	@SystemLog(target = SystemLogTarget.COMMON_CODE)
	public Boolean removeAuthoName(CommonCodeDTO common) {
		Integer authoIdx = common.getCommonCodeIdx();
		int existRoleAuthoCount = organizationMapper.countRoleAutho(authoIdx);
		
		if(existRoleAuthoCount == 0) {
			//삭제할 권한이 직무에 부여되지 않았을 경우 삭제
			organizationMapper.deleteAutho(authoIdx);
		}
		
		return existRoleAuthoCount == 0;
	}
	
	//권한 추가
	@SystemLog(target = SystemLogTarget.COMMON_CODE)
	public Boolean addAutho(CommonCodeDTO common) {
		
		int insertCount = organizationMapper.insertAutho(common);

		return insertCount > 0;
	}
	
	//부서 정보 가져오기
	public CommonCodeDTO selectDept(Integer departmentIdx) {
		
		return organizationMapper.selectDept(departmentIdx);
	}
	//팀 정보 가져오기
	public TeamDTO selectTeam(Integer teamIdx) {
		
		return organizationMapper.selectTeam(teamIdx);
	}
	//직무 정보가져오기
	public RoleDTO selectRole(Integer roleIdx) {
		
		return organizationMapper.selectRole(roleIdx);
	}
	//권한정보가져오기
	public CommonCodeDTO selectAuthoName(CommonCodeDTO common) {

		return organizationMapper.selectAuthoName(common);
	}

	
}













