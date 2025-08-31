package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.transport.dto.AdministrativeRegionDTO;
import com.itwillbs.keanu_coffee.transport.dto.MappingDTO;

public interface RegionMapper {

	// 구역 등록
	void insertRegion(String regionName);

	// 구역 리스트
	List<CommonCodeDTO> selectRegionList();
	
	// 행정구역 리스트
	List<AdministrativeRegionDTO> selectAdministrativeRegionList();

	// 구역 이름 수정
	void updateRegion(@Param("commonCodeIdx") Integer commonCodeIdx,@Param("commonCodeName") String commonCodeName);

	// 구역 이름 중복 검사
	int countRegionName(String regionName);

	// 구역 삭제
	void deleteRegion(Integer commonCodeIdx);

	// 구역 매핑 등록
	void insertMapping(MappingDTO mapping);

	// 구역별 행정 리스트
	List<MappingDTO> selectMappingRegionList();

	// 매핑된 행정구역 삭제
	void deleteMapping(Integer idx);

	// 매핑된 행정구역 그룹 삭제
	void deleteAllMapping(List<Integer> idxList);

	// 매핑 정보 조회
	MappingDTO findByIdx(Integer idx);
}
