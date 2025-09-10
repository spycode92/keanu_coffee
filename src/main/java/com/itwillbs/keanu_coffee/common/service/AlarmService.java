package com.itwillbs.keanu_coffee.common.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.common.dto.AlarmDTO;
import com.itwillbs.keanu_coffee.common.mapper.AlarmMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AlarmService {
	private final AlarmMapper alarmMapper;
	
	//알람정보조회
	public List<AlarmDTO> getAlarm(Integer empIdx) {
		
		return alarmMapper.selectAlarm(empIdx);
	}

	//알람상태업그레이드
	public Boolean modifyAlarmStatus(Integer alarmIdx) {
		int updateCount = alarmMapper.updateAlarmStatus(alarmIdx);
		
		return updateCount > 0;
	}

}
