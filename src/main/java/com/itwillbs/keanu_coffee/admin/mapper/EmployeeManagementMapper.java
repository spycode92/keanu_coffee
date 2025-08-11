package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeDTO;

public interface EmployeeManagementMapper {
	//회원 추가
	int insertEmployeeInfo(EmployeeDTO employee);

	// 회원정보 검색
	EmployeeDTO selectEmployeeInfo(String empId);

}
