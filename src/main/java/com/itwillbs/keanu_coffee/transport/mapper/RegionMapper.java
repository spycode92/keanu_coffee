package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

public interface RegionMapper {

	// 구역 등록
	void insertRegion(String regionName);

	// 구역 리스트
	List<CommonCodeDTO> selectRegionList();

}
