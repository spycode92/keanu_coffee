package com.itwillbs.keanu_coffee.common.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.mapper.PurchaseOrderMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {
	
	private final PurchaseOrderMapper purchaseOrderMapper;
	
	public List<PurchaseOrderDTO> orderDetail() {
		return purchaseOrderMapper.orderDetail();
	}
	
}
