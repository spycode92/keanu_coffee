package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;

public interface EmployeeManagementMapper {
	//회원 추가
	int insertEmployeeInfo(EmployeeInfoDTO employee);

	// 회원정보 검색
	EmployeeInfoDTO selectEmployeeInfo(String empId);
	
	// 회원직책 NULL로 변경
	void updateRoleToNull(Long roleIdx);
	// 팀 NULL로 바꾸기
	void updateTeamToNull(Long teamIdx);

	void updateDeptTeamRoleToNull(Long departmentIdx);

}
