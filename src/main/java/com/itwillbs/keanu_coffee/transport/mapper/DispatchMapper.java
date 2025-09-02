package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;

public interface DispatchMapper {

	// 배차 요청 리스트
	List<DispatchRegionGroupViewDTO> selectDispatchList();

}
