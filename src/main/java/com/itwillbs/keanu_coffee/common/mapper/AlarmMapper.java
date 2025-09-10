package com.itwillbs.keanu_coffee.common.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.AlarmDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
@Mapper
public interface AlarmMapper {

	List<AlarmDTO> selectAlarm(Integer empIdx);

	int updateAlarmStatus(Integer alarmIdx);


	
	
	


}
