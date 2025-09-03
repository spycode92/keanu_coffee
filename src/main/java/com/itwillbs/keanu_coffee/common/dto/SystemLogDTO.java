package com.itwillbs.keanu_coffee.common.dto;

import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;
@Data
public class SystemLogDTO {
	private Integer logIdx;
	//누가
	private String empNo;
	//어디서
	private String section;
	private String subSection;
	//무엇을
	private String target;
	private Integer targetIdx;
	//언제
	private LocalDateTime startTime;
	private LocalDateTime endTime;
	private long elapsedTime;
	//어떻게 
	private String logMessage;
	
	private LocalDateTime createdAt;
    
    private List<CommonCodeDTO> commonCodeList;
}
