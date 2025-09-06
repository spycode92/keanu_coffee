package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;

public interface TotalDashBoardMapper {
	// 일별 입고 정보조회
	List<TotalDashBoardDTO> selectInboundDashDataByDay(@Param("startDate")String startDate, @Param("endDate")String endDate);
	//주별 입고 정보 조회
	List<TotalDashBoardDTO> selectInboundDashDataByWeek(@Param("startDate")String startDate, @Param("endDate")String endDate);
	// 월별 입고 정보 조회
	List<TotalDashBoardDTO> selectInboundDashDataByMonth(@Param("startDate")String startDate, @Param("endDate")String endDate);


}
