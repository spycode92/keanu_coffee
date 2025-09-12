package com.itwillbs.keanu_coffee.common.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.common.dto.AlarmDTO;
import com.itwillbs.keanu_coffee.common.mapper.AlarmMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AlarmService {
	private final AlarmMapper alarmMapper;
	private final EmployeeManagementMapper employeeManagementMapper;
	
	//알람정보조회
	public List<AlarmDTO> getAlarm(Integer empIdx) {
		
		return alarmMapper.selectAlarm(empIdx);
	}

	//알람상태업그레이드
	public Boolean modifyAlarmStatus(Integer alarmIdx) {
		int updateCount = alarmMapper.updateAlarmStatus(alarmIdx);
		
		return updateCount > 0;
	}
	
	//직책별 알림 입력
	public void insertAlarmByRole(AlarmDTO alarmDTO) {
		List<EmployeeInfoDTO> employeeList = employeeManagementMapper.selectEmpInfoByRole(alarmDTO.getRoleName());
		
		for(EmployeeInfoDTO employee : employeeList) {
			alarmDTO.setEmpIdx(employee.getEmpIdx());
			int insertCount = alarmMapper.insertAlarm(alarmDTO);
			
		}
	}
	
	//개인 알림 입력
	public void insertAlarm(AlarmDTO alarmDTO) {
		
		int insertCount = alarmMapper.insertAlarm(alarmDTO);
		
	}

}
