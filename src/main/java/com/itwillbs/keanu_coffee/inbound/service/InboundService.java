package com.itwillbs.keanu_coffee.inbound.service;


import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.common.aop.annotation.WorkingLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.WorkingLogTarget;
import com.itwillbs.keanu_coffee.inbound.dto.CommitInventoryDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundManagementDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundProductDetailDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundStatusHistoryDTO;
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
		InboundDetailDTO inboundDetailData = inboundMapper.selectInboundDetailData(ibwaitIdx);
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		inboundDetailData.setArrivalDateFormatted(
			inboundDetailData.getArrivalDate().format(formatter)
		);
		
		return inboundDetailData;
	}

	// Detail 상품정보 리스트 조회
	public List<InboundProductDetailDTO> getInboundProductDetail(String orderNumber) {
		return inboundMapper.selectInboundProductDetail(orderNumber);
	}
	
	// Inspection 로케이션 수정
	private static final Map<String, Integer> LOCATION_MAP = Map.of(
	    "Location_F", 9999,
	    "Location_G", 9998,
	    "Location_H", 9997
	);
	public void updateLocation(Long ibwaitIdx, String inboundLocation) {
	    Integer inboundLocationNum = LOCATION_MAP.get(inboundLocation);
	    if(inboundLocationNum == null) return;
	    inboundMapper.updateLocation(ibwaitIdx, inboundLocationNum);
	}
	
	// 매니저 검색
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
//	    inboundMapper.updatePurchaseOrderItemAfterInspection(dto); // purchase order는 수정하지 않기로.
	}

	
	// 상태 업데이트(검수중)
	@WorkingLog(target = WorkingLogTarget.INBOUND_INSPECTION)
	public void updateInboundStatusInspection(Integer ibwaitIdx, String status) {
	    inboundMapper.updateInboundStatus(ibwaitIdx, status);
	}
	
	// 상태 업데이트(재고등록완료)
	@WorkingLog(target = WorkingLogTarget.INBOUND_COMPLETE)
	public void updateInboundStatusInboundComplete(Integer ibwaitIdx, String status) {
		inboundMapper.updateInboundStatus(ibwaitIdx, status);
	}
	
	// 재고 완전등록
	public void insertInventory(CommitInventoryDTO req) {
	    for (CommitInventoryDTO.InventoryItemDTO item : req.getItems()) {
	        inboundMapper.insertInventory(item);
	    }
	}
	
	
	// detail.로그조회
	public List<InboundStatusHistoryDTO> getInboundStatusHistory(Integer ibwaitIdx) {
		return inboundMapper.selectInboundStatusHistory(ibwaitIdx);
	}

	
	


}
