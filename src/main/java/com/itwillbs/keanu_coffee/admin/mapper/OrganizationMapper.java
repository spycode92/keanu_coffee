package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;

@Mapper
public interface OrganizationMapper {
	//부서목록 받아오기
	List<DepartTeamRoleDTO> getDepartmentInfo();
	
	//해당부서 팀목록 받아오기
	List<DepartTeamRoleDTO> getTeamsInfoByDepartmentIdx(int departmentIdx);
	
	//해당부서의 직책목록 받아오기
	List<DepartTeamRoleDTO> getRolesInfoByDepartmentIdx(int departmentIdx);
	
	// 부서추가
	void insertDepartment(DepartTeamRoleDTO departTeamRoleDTO);
	
	// 팀추가
	void insertTeam(DepartTeamRoleDTO departTeamRoleDTO);
	
	// 직책추가
	void insertRole(DepartTeamRoleDTO departTeamRoleDTO);
	
	// 직책삭제
	int deleteRole(Long roleIdx);
	
	// 직책,메뉴,권한 테이블이 가지고있는 직책 삭제
	void deleteRoleMenuAuthoByRoleIdx(Long roleIdx);
	
	// 팀 삭제
	int deleteTeam(Long teamIdx);
	
	//부서에 속한 팀목록
	List<DepartTeamRoleDTO> departTeamList(Long departmentIdx);
	
	//부서에 속한 직책목록
	List<DepartTeamRoleDTO> departRoleList(Long departmentIdx);
	
	//부서삭제
	int deleteDepartment(Long departmentIdx);
	//부서이름 변경
	int updateDepartment(@Param("idx") int idx, @Param("departmentName") String departmentName);
	//팀이름 변경
	int updateTeam(@Param("idx")int idx, @Param("teamName")String teamName);
	//직책이름 변경
	int updateRole(@Param("idx")int idx, @Param("roleName")String roleName);
	
}
