package com.itwillbs.keanu_coffee.inbound.service;

import java.time.format.DateTimeFormatter;
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
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.mapper.InboundMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InboundService {
	
	private final InboundMapper inboundMapper;
	
	// management list 조회
	public List<InboundManagementDTO> getAllinboundWaitingInfo() {
		
		List<InboundManagementDTO> orderDetailList = inboundMapper.selectInboundWaitingInfo();
		
		// LocalDateTime → String 포맷 처리
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
	    orderDetailList.forEach(dto -> {
	        if (dto.getArrivalDate() != null) {
	            dto.setArrivalDateStr(dto.getArrivalDate().format(formatter));
	        }
	    });
		
		return orderDetailList;
	}

	// Detail 보드 데이터 조회
	public InboundDetailDTO getInboundDetailData(int ibwaitIdx) {
		return inboundMapper.selectInboundDetailData(ibwaitIdx);
	}

	// Detail 상품정보 리스트 조회
	public List<InboundProductDetailDTO> getInboundProductDetail(String orderNumber) {
		return inboundMapper.selectInboundProductDetail(orderNumber);
	}

	
	
}
