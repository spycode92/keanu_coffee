package com.itwillbs.keanu_coffee.common.mapper;

import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;

public interface LogMapper {

	void insertSystemLog(SystemLogDTO slog);
	
}
