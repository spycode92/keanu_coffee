package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;

public interface DispatchMapper {

	// 배차 요청 리스트
	List<DispatchRegionGroupViewDTO> selectDispatchList();

	// 배차 테이블 등록
	void insertDispatch(DispatchRegionGroupViewDTO dispatchRegionGroupView);

	// 배차 배정 테이블 등록
	void insertDispatchAssignment(DispatchRegionGroupViewDTO dispatchRegionGroupView);

	// 배차 매핑 테이블 등록
	void insertDispatchOrderMap(DispatchRegionGroupViewDTO dispatchRegionGroupView);

}
