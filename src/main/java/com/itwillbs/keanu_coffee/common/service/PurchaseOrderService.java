package com.itwillbs.keanu_coffee.common.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseWithSupplierDTO;
import com.itwillbs.keanu_coffee.common.mapper.PurchaseOrderMapper;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {
	
	private final PurchaseOrderMapper purchaseOrderMapper;
	
	public List<PurchaseWithSupplierDTO> orderDetail() {
		return purchaseOrderMapper.orderDetail();
	}


	
}
