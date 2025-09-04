package com.itwillbs.keanu_coffee.inbound.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseWithSupplierDTO;
import com.itwillbs.keanu_coffee.common.mapper.PurchaseOrderMapper;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.mapper.InboundMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InboundService {
	
	private final InboundMapper inboundMapper;
	private final PurchaseOrderMapper purchaseOrderMapper;
	
	// management list 조회
	public List<InboundManagementDTO> inboundWaitingInfo() {
		return inboundMapper.selectAllInboundWaitingInfo();
	}
	
	
	@Transactional
	public List<ProductDTO> getOrderDetailByOrderNum(String orderNumber) {
		// orderNumber로 orderIdx 조회
		int orderIdx = inboundMapper.searchOrderIdx(orderNumber);
		
		// orderIdx로 productIdx 조회
		List<PurchaseOrderItemDTO> productIdx = inboundMapper.searchProductIdx(orderIdx);
		
		// productIdx로 product 상세정보 조회
		List<ProductDTO> productDetail = inboundMapper.searchProductDetail(productIdx);
		
		
		return productDetail;
	}

	// 상품상세정보 조회
	public List<PurchaseWithSupplierDTO> getOrderDetailByOrderIdx(int orderIdx) {
		return purchaseOrderMapper.getOrderDetailByOrderIdx(orderIdx);
	}
	
	// 담당사원명 검색
	public List<EmployeeInfoDTO> getInboundStaffNameList() {
		return inboundMapper.getInboundStaffNameList();
	}

	public String getSupplierName(int supplierIdx) {
		return inboundMapper.getSupplierName(supplierIdx);
	}


	public InboundDetailDTO getInboundDetailData(int ibwaitIdx) {
		return inboundMapper.getInboundDetailData(ibwaitIdx);
	}

	
	
}
