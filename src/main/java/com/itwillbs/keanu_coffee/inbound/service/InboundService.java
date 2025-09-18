package com.itwillbs.keanu_coffee.inbound.service;


import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;

import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.aop.annotation.WorkingLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.WorkingLogTarget;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseWithSupplierDTO;
import com.itwillbs.keanu_coffee.common.mapper.PurchaseOrderMapper;
import com.itwillbs.keanu_coffee.inbound.controller.InboundController.EmployeeOption;

import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;
import com.itwillbs.keanu_coffee.inbound.mapper.InboundMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InboundService {
	
	private final InboundMapper inboundMapper;
	
	// management 페이징 전체 개수
	public int getInboundCount(Map<String, Object> searchParams) {
		return inboundMapper.selectInboundCount(searchParams);
	}
	
	// management list 조회 (페이징 적용)
	public List<InboundManagementDTO> getInboundList(Map<String, Object> searchParams, int startRow, int listLimit) {
		searchParams.put("startRow", startRow);
		searchParams.put("listLimit", listLimit);

		List<InboundManagementDTO> orderDetailList = inboundMapper.selectInboundList(searchParams);

		// 날짜 포맷팅
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
	
	// Detail 로케이션 수정
	public void updateLocation(Long ibwaitIdx, String inboundLocation) {
		inboundMapper.updateLocation(ibwaitIdx, inboundLocation);
	}

	public List<EmployeeInfoDTO> findManagers() {
		return inboundMapper.selectEmployeeList();
	}

	@Transactional
	public void updateManagers(List<Integer> ibwaitIdxList, Long managerIdx, String managerName) {
	    if(ibwaitIdxList == null || ibwaitIdxList.isEmpty()) return;
	    inboundMapper.updateManagers(ibwaitIdxList, managerIdx, managerName);
	}
	
	// 검수완료 데이터 확인
	public boolean findDataExists(Long ibwaitIdx, Long productIdx, String lotNumber) {
		return inboundMapper.selectDataExists(ibwaitIdx, productIdx, lotNumber) > 0;
	}
	
	// 검수 완료시 데이터 저장/수정
	@Transactional
	public void inspectionCompleteUpdate(ReceiptProductDTO dto, boolean exists) {
		if (exists) {
			inboundMapper.updateReceiptProduct(dto);
		} else {
			inboundMapper.insertReceiptProduct(dto);
		}
	    inboundMapper.updatePurchaseOrderItemAfterInspection(dto);
	}
	


}
