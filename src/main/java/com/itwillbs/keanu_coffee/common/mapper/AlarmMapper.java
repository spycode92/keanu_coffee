package com.itwillbs.keanu_coffee.common.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.AlarmDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
@Mapper
public interface AlarmMapper {
	//알림리스트 구해오기[ajax]
	List<AlarmDTO> selectAlarm(@Param("empIdx")Integer empIdx, @Param("startRow")int startRow, @Param("listLimit")int listLimit);
	
	// 알림 상태 변경[읽음표시]
	int updateAlarmStatus(Integer alarmIdx);
	
	//알림 추가 
	int insertAlarm(AlarmDTO alarmDTO);
	
	//알림 갯수새기
	int selectAlarmCount(Integer empIdx);

	List<AlarmDTO> selectAlarmInAjax(Integer empIdx);
	//알림 전부 읽음처리
	int updateAllAlarmStatus(Integer empIdx);


	
	
	


}
