package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

public interface RegionMapper {

	// 구역 등록
	void insertRegion(String regionName);

	// 구역 리스트
	List<CommonCodeDTO> selectRegionList();

	// 구역 이름 수정
	void updateRegion(@Param("commonCodeIdx") Integer commonCodeIdx,@Param("commonCodeName") String commonCodeName);

	// 구역 이름 중복 검사
	int countRegionName(String regionName);

	// 구역 삭제
	void deleteRegion(Integer commonCodeIdx);
}
