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
	
	//권한목록 가져오기
	public List<CommonCodeDTO> getAuthorityList() {
		return organizationMapper.selectAuthorityList();
	}
	
	//직책별 권한정보 가져오기
	public List<Map<String, Object>> getAuthrityInfo(Integer roleIdx) {
		return organizationMapper.selectAuthorityInfo(roleIdx);
	}
	//직책별 권한 업데이트
	@Transactional
	public void modifyRoleAutho(Map<String, Object> data) {
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
            // 성공시 모든 변경사항 커밋
        } catch (Exception e) {
            // 실패시 모든 변경사항 롤백
            throw new RuntimeException("권한 수정 실패: " + e.getMessage(), e);
        }
		
	}
	//권한이름수정
	public Boolean modifyAuthoName(Map<String, Object> data) {
		Integer authoIdx = (Integer)data.get("authoIdx");
		String authoName = (String)data.get("authoName");
		int updateCount = organizationMapper.updateAuthoName(authoIdx, authoName);
		return updateCount > 0;
	}

	//권한삭제
	public Map<String, String> removeAuthoName(Integer authoIdx) {
		Map<String, String> result = new HashMap<>();
		int exitsRoleAuthoCount = organizationMapper.countRoleAutho(authoIdx);
		// 삭제할 권한이 직책에 부여되어 있다면
		if (exitsRoleAuthoCount > 0) {
			result.put("result", "fail");
			result.put("msg", "권한이 부여된 직책이 있습니다.");
			return result;
		}
		//삭제할 권한이 직책에 부여되지 않았을 경우 삭제
		organizationMapper.deleteAutho(authoIdx);
		result.put("result", "success");
		result.put("msg", "권한이 삭제되었습니다.");
		return result;
	}
	
	//권한 추가
	public Map<String, String> addAutho(Map<String, Object> data) {
		Map<String, String> result = new HashMap<>();
		String authoCode = (String)data.get("authoCode");
		String authoName = (String)data.get("authoName");
		int insertCount = organizationMapper.insertAutho(authoCode, authoName);
		if(insertCount > 0) {
			result.put("result", "success");
			result.put("msg", "권한이 추가되었습니다.");
		}
		result.put("result", "fail");
		result.put("msg", "권한 추가에 실패하였습니다.");
		return result;
	}

	
}













