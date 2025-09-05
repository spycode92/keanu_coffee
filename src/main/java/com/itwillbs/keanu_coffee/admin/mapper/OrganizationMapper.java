package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.RoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.dto.TeamDTO;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

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
	Integer deleteRole(Integer roleIdx);
	
	// 직책,메뉴,권한 테이블이 가지고있는 직책 삭제
	void deleteRoleMenuAuthoByRoleIdx(Integer roleIdx);
	
	// 팀 삭제
	Integer deleteTeam(Integer teamIdx);
	
	//부서에 속한 팀목록
	List<TeamDTO> departTeamList(Integer departmentIdx);
	
	//부서에 속한 직책목록
	List<RoleDTO> departRoleList(Integer departmentIdx);
	
	//부서삭제
	Integer deleteDepartment(Integer departmentIdx);
	//부서이름 변경
	Integer updateDepartment(@Param("departmentIdx") int departmentIdx, @Param("departmentName") String departmentName);
	//팀이름 변경
	Integer updateTeam(@Param("teamIdx")int teamIdx, @Param("teamName")String teamName);
	//직책이름 변경
	Integer updateRole(@Param("roleIdx")int roleIdx, @Param("roleName")String roleName);
	
	//직책 팀, 부서 정보 조회
	List<Map<String, Object>> getOrgData();
	
	//권한목록조회 
	List<CommonCodeDTO> selectAuthorityList();
	//직책별 권한정보조회
	List<Map<String, Object>> selectAuthorityInfo(Integer roleIdx);
	//직책별 권한정보 삭제
	void deleteAuthorities(@Param("roleIdx") Integer roleIdx, @Param("removedAuthorities")List<Integer> removedAuthorities);
	// 직책별 권한정보 추가
	void insertAuthorities(@Param("roleIdx")Integer roleIdx, @Param("addedAuthorities")List<Integer> addedAuthorities);
	//권한이름수정
	int updateAuthoName(@Param("authoIdx")Integer authoIdx, @Param("authoName")String authoName);
	//권한을 가진 직책수 확인
	int countRoleAutho(Integer authoIdx);
	// 권한 삭제
	void deleteAutho(Integer authoIdx);
	// 권한 추가
	int insertAutho(CommonCodeDTO common);
	// 부서 이름 조회
	CommonCodeDTO selectDept(Integer departmentIdx);
	//팀 이름 조회
	TeamDTO selectTeam(Integer teamIdx);
	// 직책이름 조회
	RoleDTO selectRole(Integer roleIdx);
	// 권한조회(권한idx로)
	List<CommonCodeDTO> selectAuthoByAuthoIdx(List<Integer> addAuthoritiesIdx);
	//권한정보조회(단건)
	CommonCodeDTO selectAuthoName(CommonCodeDTO common);

	
}
