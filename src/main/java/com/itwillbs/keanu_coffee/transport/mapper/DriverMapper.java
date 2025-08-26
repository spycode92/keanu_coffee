package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;

public interface DriverMapper {

	// 차량 배정 가능한 기사 리스트
	List<EmployeeInfoDTO> selectDriverList();

	// 페이징을 위한 운전사 수
	int selectDriverCount(@Param("filter") String filter, @Param("searchKeyword") String searchKeyword);

}
