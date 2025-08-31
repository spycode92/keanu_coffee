package com.itwillbs.keanu_coffee.transport.mapper;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.transport.dto.RouteDTO;

public interface RouteMapper {

	// 최대 delivery_sequence 조회
	Integer findMaxSequence(Integer regionIdx);

	// 배송순서 등록
	void insertRoute(RouteDTO route);

	// 배송 경로에서 지점 삭제
	void deleteByRegionAndFranchise(@Param("regionIdx") Integer regionIdx, @Param("franchiseIdx") Integer franchiseIdx);

}
