package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.admin.mapper.TotalDashBoardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TotalDashBoardService {
	private final TotalDashBoardMapper totalDashBoardMapper;
	
	//일별 입고량 대시보드 조회
	public List<TotalDashBoardDTO> getInboundDashData(String needData, String startDate, String endDate) {
		
		if(needData.equals("daily")) {
			return totalDashBoardMapper.selectInboundDashDataByDay(startDate, endDate);
		}else if(needData.equals("weekly")) {
			return totalDashBoardMapper.selectInboundDashDataByWeek(startDate, endDate); 
		}else {
			return totalDashBoardMapper.selectInboundDashDataByMonth(startDate, endDate);
		}
		
		
	}

	public List<TotalDashBoardDTO> getOutboundDashData(String needData, String startDate, String endDate) {
		if(needData.equals("daily")) {
			return totalDashBoardMapper.selectOutboundDashDataByDay(startDate, endDate);
		}else if(needData.equals("weekly")) {
			return totalDashBoardMapper.selectOutboundDashDataByWeek(startDate, endDate); 
		}else {
			return totalDashBoardMapper.selectOutboundDashDataByMonth(startDate, endDate);
		}
	}
	

}
