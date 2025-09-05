package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.SystemNotificationMapper;
import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SystemNotificationService {
	private final SystemNotificationMapper systemNotificationMapper;
	
	//알림수확인
	public int getNoticeCount(String searchType, String searchKeyword) {
		
		return systemNotificationMapper.selectNotificationCount(searchType, searchKeyword);
	}

	public List<SystemLogDTO> getNotificationList(int startRow, int listLimit, String searchType,
			String searchKeyword, String orderKey, String orderMethod) {
		
		return systemNotificationMapper.selectNotificationList(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod);
	}
}
