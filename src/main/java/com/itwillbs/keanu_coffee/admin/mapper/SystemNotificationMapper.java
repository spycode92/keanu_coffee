package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;

public interface SystemNotificationMapper {

	int selectNotificationCount(@Param("searchType")String searchType, @Param("searchKeyword")String searchKeyword);

	List<SystemLogDTO> selectNotificationList(
		@Param("startRow") int startRow, @Param("listLimit") int listLimit, 
		@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword,
		@Param("orderKey")String orderKey, @Param("orderMethod")String orderMethod);

}
