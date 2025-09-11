package com.itwillbs.keanu_coffee.inbound.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.inbound.controller.InboundController.EmployeeOption;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;

@Mapper
public interface InboundMapper {
	
	// management 전체 리스트 조회
	List<InboundManagementDTO> selectInboundWaitingInfo();
	
	// detail 기본 정보 조회
	InboundDetailDTO selectInboundDetailData(int ibwaitIdx);
	
	// detail 상품 정보 조회 
	List<InboundProductDetailDTO> selectInboundProductDetail(String orderNumber);
	
	// detail 로케이션 인서트&업데이트
	void updateLocation(@Param("ibwaitIdx") Long ibwaitIdx, @Param("inboundLocation") String inboundLocation);

	List<EmployeeInfoDTO> selectEmployeeList();

	void updateManager(@Param("ibwaitIdx") Long ibwaitIdx, @Param("managerName") String managerName);
	
	// 검수 데이터 여부 확인
	boolean selectDataExists(@Param("ibwaitIdx") Long ibwaitIdx, @Param("productIdx") Long productIdx, @Param("lotNumber") String lotNumber);
	
	// 검수완료 데이터 업데이트
	void updateReceiptProduct(ReceiptProductDTO dto);
	void insertReceiptProduct(ReceiptProductDTO dto);
	void updatePurchaseOrderItemAfterInspection(ReceiptProductDTO dto);
	
	


}
