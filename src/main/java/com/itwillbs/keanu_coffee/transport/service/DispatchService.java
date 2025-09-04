package com.itwillbs.keanu_coffee.transport.service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.mapper.DispatchMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DispatchService {
	private final DispatchMapper dispatchMapper;

	// 배차 요청 리스트
	public List<DispatchRegionGroupViewDTO> getDispatchList() {
		return dispatchMapper.selectDispatchList();
	}

	// 배차 등록
	@Transactional
	public void insertDispatch(DispatchRegionGroupViewDTO dispatchRegionGroupView) {
		// 배차 테이블 데이터 등록
		dispatchMapper.insertDispatch(dispatchRegionGroupView);
		Integer dispatchIdx = dispatchRegionGroupView.getDispatchIdx();
		
		// 배차 배정 테이블 데이터 등록
		dispatchMapper.insertDispatchAssignment(dispatchRegionGroupView);
		Integer dispatchAssignmentIdx = dispatchRegionGroupView.getDispatchAssignmentIdx();
		
		List<Integer> orderIdList = dispatchRegionGroupView.getOrderList();
		
		for (Integer outboundOrderIdx : orderIdList) {
			dispatchRegionGroupView.setOutboundOrderIdx(outboundOrderIdx);
			
			// 배차 매핑 테이블 데이터 등록
			dispatchMapper.insertDispatchOrderMap(dispatchRegionGroupView);
		}
				
	}
	

}
