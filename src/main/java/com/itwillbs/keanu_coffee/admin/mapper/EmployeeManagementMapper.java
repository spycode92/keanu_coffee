package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;

public interface EmployeeManagementMapper {
	// 로그인용 아이디로 회원정보 조회
	EmployeeInfoDTO selectEmployeeInfoById(String empNo);
	
	//직원목록 선택
	List<EmployeeInfoDTO> selectEmployeeList(
			@Param("startRow") int startRow, @Param("listLimit") int listLimit, 
			@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword,
			@Param("orderKey")String orderKey, @Param("orderMethod")String orderMethod);

	// 직원목록 수
	int countEmployee(@Param("searchType")String searchType, @Param("searchKeyword")String searchKeyword);

	
	
	//회원 추가
	int insertEmployeeInfo(EmployeeInfoDTO employee);
	
	// 회원직책 NULL로 변경
	void updateRoleToNull(Long roleIdx);
	// 팀 NULL로 바꾸기
	void updateTeamToNull(Long teamIdx);
	// 부서, 팀, 직책 널로바꾸기
	void updateDeptTeamRoleToNull(Long departmentIdx);
	
	// idx로 회원정보 조회하기
	EmployeeInfoDTO selectOneEmployeeInfoByEmpIdx(Integer empIdx);
	
	// 회원 정보 업데이트하기
	int updateEmployeeInfo(EmployeeInfoDTO employee);



}
