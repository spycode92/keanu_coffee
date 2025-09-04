package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.admin.mapper.SystemNotificationMapper;
import com.itwillbs.keanu_coffee.admin.mapper.TotalDashBoardMapper;
import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TotalDashBoardService {
	private final TotalDashBoardMapper totalDashBoardMapper;
	
	//일별 입고량 대시보드 조회
	public List<TotalDashBoardDTO> getTotalDashBoardByDay() {
		return totalDashBoardMapper.selectTotalDashBoardByDay()
	}
	

}
