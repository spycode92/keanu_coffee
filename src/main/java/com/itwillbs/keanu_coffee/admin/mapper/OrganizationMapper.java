package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.RoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.dto.TeamDTO;

@Mapper
public interface OrganizationMapper {
	//부서목록 받아오기
	List<DepartmentDTO> getDepartmentInfo();
	
	//해당부서 팀목록 받아오기
	List<TeamDTO> getTeamsInfoByDepartmentIdx(int departmentIdx);
	
	//해당부서의 직책목록 받아오기
	List<RoleDTO> getRolesInfoByDepartmentIdx(int departmentIdx);
	
	// 부서추가
	void insertDepartment(DepartmentDTO departTeamRoleDTO);
	
	// 팀추가
	void insertTeam(TeamDTO teamdto);
	
	// 직책추가
	void insertRole(RoleDTO roleDTO);
	
	// 직책삭제
	int deleteRole(Integer integer);
	
	// 직책,메뉴,권한 테이블이 가지고있는 직책 삭제
	void deleteRoleMenuAuthoByRoleIdx(Integer integer);
	
	// 팀 삭제
	int deleteTeam(Integer teamIdx);
	
	//부서에 속한 팀목록
	List<DepartmentDTO> departTeamList(Long departmentIdx);
	
	//부서에 속한 직책목록
	List<DepartmentDTO> departRoleList(Long departmentIdx);
	
	//부서삭제
	int deleteDepartment(Long departmentIdx);
	//부서이름 변경
	int updateDepartment(@Param("idx") int idx, @Param("departmentName") String departmentName);
	//팀이름 변경
	int updateTeam(@Param("teamIdx")int teamIdx, @Param("teamName")String teamName);
	//직책이름 변경
	int updateRole(@Param("roleIdx")int roleIdx, @Param("roleName")String roleName);
	
	//직책 팀, 부서 정보 가져오기
	List<Map<String, Object>> getOrgData();
	
}
