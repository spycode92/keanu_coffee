package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.transport.dto.RegionFranchiseRouteDTO;
import com.itwillbs.keanu_coffee.transport.dto.RouteDTO;

public interface RouteMapper {

	// 최대 delivery_sequence 조회
	Integer findMaxSequence(Integer regionIdx);

	// 배송순서 등록
	void insertRoute(RouteDTO route);

	// 배송 경로에서 지점 삭제
	void deleteByRegionAndFranchise(@Param("regionIdx") Integer regionIdx, @Param("franchiseIdx") Integer franchiseIdx);

	// 구역별 지점 배송 순서
	List<RegionFranchiseRouteDTO> selectFranchiseRoute();

	// 배송 순서 변경
	void updateSequence(RegionFranchiseRouteDTO dto);

	// 경로 조회
	RouteDTO selectFranchise(Integer franchiseIdx);

}
