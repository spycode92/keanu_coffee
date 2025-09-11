package com.itwillbs.keanu_coffee.outbound.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundManagementDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundProductDetailDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;

@Mapper
public interface OutboundMapper {
	
	// 출고 전체 목록 조회
	List<OutboundManagementDTO> selectObManagementList();
	
	 // 출고 기본정보 상세 조회
    OutboundManagementDTO selectOutboundDetail(@Param("obwaitNumber") String obwaitNumber, @Param("outboundOrderIdx") Long outboundOrderIdx);

    // 출고 품목 리스트 조회
    List<OutboundProductDetailDTO> selectOutboundProductDetail(@Param("outboundOrderIdx") Long outboundOrderIdx);
	
}
