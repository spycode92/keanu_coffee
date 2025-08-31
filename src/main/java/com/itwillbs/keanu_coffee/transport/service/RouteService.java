package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.transport.dto.RegionFranchiseRouteDTO;
import com.itwillbs.keanu_coffee.transport.dto.RouteDTO;
import com.itwillbs.keanu_coffee.transport.mapper.RouteMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RouteService {
	private final RouteMapper routeMapper;

	// 배송 순서 입력
	@Transactional
	public void addRoute(RouteDTO route) {
		Integer maxSeq = routeMapper.findMaxSequence(route.getRegionIdx());
		
		if (maxSeq == 0) {
			maxSeq = 0;
		}
		
		// 다음 순번 부여
		route.setDeliverySequence(maxSeq + 1);
		
		routeMapper.insertRoute(route);
	}

	// 배송 경로에서 지점 삭제
	public void deleteByRegionAndFranchise(Integer regionIdx, Integer franchiseIdx) {
		routeMapper.deleteByRegionAndFranchise(regionIdx, franchiseIdx);
	}

	// 구역별 지점 배송 순서
	public List<RegionFranchiseRouteDTO> getFranchiseRouteList() {
		return routeMapper.selectFranchiseRoute();
	}
	
	// 순서 변경
	public void reorderRoutes(List<RegionFranchiseRouteDTO> franchiseOrders) {
		for (RegionFranchiseRouteDTO dto : franchiseOrders) {
			routeMapper.updateSequence(dto);
		}
		
	}

}
