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
	// 일별 출고 정보조회
	List<TotalDashBoardDTO> selectOutboundDashDataByDay(@Param("startDate")String startDate, @Param("endDate")String endDate);
	// 주별 출고 정보 조회
	List<TotalDashBoardDTO> selectOutboundDashDataByWeek(@Param("startDate")String startDate, @Param("endDate")String endDate);
	// 월별 출고 정보 조회
	List<TotalDashBoardDTO> selectOutboundDashDataByMonth(@Param("startDate")String startDate, @Param("endDate")String endDate);
	// 일별 폐기 정보조회
	List<TotalDashBoardDTO> selectDisposalDashDataByDay(@Param("startDate")String startDate, @Param("endDate")String endDate);
	// 주별 폐기 정보 조회
	List<TotalDashBoardDTO> selectDisposalDashDataByWeek(@Param("startDate")String startDate, @Param("endDate")String endDate);
	// 월별 폐기 정보 조회
	List<TotalDashBoardDTO> selectDisposalDashDataByMonth(@Param("startDate")String startDate, @Param("endDate")String endDate);
	// 재고정보 가져오기
	List<TotalDashBoardDTO> selectInventory();
	// 로케이션 용적율, 사용율 사용항목 조회
	List<TotalDashBoardDTO> selectLocation();


}
