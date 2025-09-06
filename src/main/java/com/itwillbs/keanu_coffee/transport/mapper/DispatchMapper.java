package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.transport.dto.DispatchAssignmentDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegisterRequestDTO;

public interface DispatchMapper {
	
	// 페이징을 위한 배차 카운트
	int selectDispatchCount(@Param("filter") String filter, @Param("searchKeyword") String searchKeyword);

	// 배차 리스트
	List<DispatchRegionGroupViewDTO> selectAllDispatch(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("filter") String filter,
			@Param("searchKeyword") String searchKeyword);
	
	// 배차 요청 리스트
	List<DispatchRegionGroupViewDTO> selectDispatchList();

	// 배차 테이블 등록
	void insertDispatch(DispatchRegisterRequestDTO request);

	// 배차 배정 테이블 등록
	void insertDispatchAssignment(DispatchAssignmentDTO driver);

	// 배차 매핑 테이블 등록
	void insertDispatchOrderMap(@Param("outboundOrderIdx") Integer outboundOrderIdx,
			@Param("dispatchIdx") Integer dispatchIdx);

	// 출고 주문 테이블 상태 변경
	void updateOutboundOrderStatus(@Param("outboundOrderIdx") Integer outboundOrderIdx, @Param("status") String status);

	// 출고Idx로 배차idx 조회
	Integer selectByorderIdList(Integer outboundOrderIdx);

	// 배차 상태 취소로 변경
	void updateDispatchStatus(@Param("dispatchIdx") Integer dispatchIdx, @Param("status") String status);

	// 배차 상태 확인
	String selectDispatchStatus(int dispatchIdx);

	// 배차 상세 정보(적재 전)
	DispatchRegionGroupViewDTO selectDispatchSummary(@Param("dispatchIdx") Integer dispatchIdx, @Param("vehicleIdx") Integer vehicleIdx);

	// 배차 상제 정보(적재 완료 후)
	DispatchRegionGroupViewDTO selectDispatchDetail(int dispatchIdx);


}
