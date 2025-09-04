package com.itwillbs.keanu_coffee.inbound.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;

@Mapper
public interface InboundMapper {
	
	// orderNumber로 orderIdx 조회
	int searchOrderIdx(String orderNumber);
	
	// orderIdx로 productIdx 조회
	List<PurchaseOrderItemDTO> searchProductIdx(int orderIdx);
	
	// productIdx로 product 상세정보 조회
	List<ProductDTO> searchProductDetail(List<PurchaseOrderItemDTO> productIdx);
	
	//
	List<EmployeeInfoDTO> getInboundStaffNameList();
	
	// 회사명 확인하기
	String getSupplierName(int supplierIdx);

	List<InboundManagementDTO> selectAllInboundWaitingInfo();

	InboundDetailDTO getInboundDetailData(int ibwaitIdx);
	
	


}
