package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.SystemNotificationMapper;
import com.itwillbs.keanu_coffee.admin.mapper.WorkingLogMapper;
import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class WorkingLogService {
	private final WorkingLogMapper workingLogMapper;
	
	//알림수확인
	public int getWorkingLogCount(String searchType, String searchKeyword) {
		
		return workingLogMapper.selectWorkingLogCount(searchType, searchKeyword);
	}

	public List<SystemLogDTO> getWorkingLogList(int startRow, int listLimit, String searchType,
			String searchKeyword, String orderKey, String orderMethod) {
		
		return workingLogMapper.selectWorkingLogList(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod);
	}

}
