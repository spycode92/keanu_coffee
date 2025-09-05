package com.itwillbs.keanu_coffee.common.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.mapper.PurchaseOrderMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {

	
	public String getTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber() {
		
		return purchaseOrderMapper.selectTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber();
	}
	
}
