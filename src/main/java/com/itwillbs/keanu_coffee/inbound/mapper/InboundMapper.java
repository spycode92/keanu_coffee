package com.itwillbs.keanu_coffee.inbound.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;

@Mapper
public interface InboundMapper {
	
	// management 전체 리스트 조회
	List<InboundManagementDTO> selectInboundWaitingInfo();
	
	// detail 기본 정보 조회
	InboundDetailDTO selectInboundDetailData(int ibwaitIdx);
	
	// detail 상품 정보 조회 
	List<InboundProductDetailDTO> selectInboundProductDetail(String orderNumber);
	
	


}
