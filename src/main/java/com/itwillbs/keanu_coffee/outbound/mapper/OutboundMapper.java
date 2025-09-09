package com.itwillbs.keanu_coffee.outbound.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundManagementDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;

@Mapper
public interface OutboundMapper {

	List<OutboundManagementDTO> selectObManagementList();
	
}
