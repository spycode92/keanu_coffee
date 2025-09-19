package com.itwillbs.keanu_coffee.outbound.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.common.aop.annotation.WorkingLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.WorkingLogTarget;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundManagementDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundProductDetailDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;
import com.itwillbs.keanu_coffee.outbound.mapper.OutboundMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OutboundService {

	private final OutboundMapper outboundMapper;
	
	// 출고지시 리스트
	public List<OutboundManagementDTO> getAllObManagementList() {
		List<OutboundManagementDTO> selectObManagementList = outboundMapper.selectObManagementList();
		return selectObManagementList;
	}
	
	// 출고 기본정보 상세 조회
    public OutboundManagementDTO getOutboundDetail(String obwaitNumber, Long outboundOrderIdx) {
    	return outboundMapper.selectOutboundDetail(obwaitNumber, outboundOrderIdx);
    };

    // 출고 품목 리스트 조회
    public List<OutboundProductDetailDTO> getOutboundProductDetail(Long outboundOrderIdx) {
    	return outboundMapper.selectOutboundProductDetail(outboundOrderIdx);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // 출고 상태 변경(대기 -> 출고준비)
    @Transactional
	public int updateStatusReady(List<Long> orderIdxList) {
		if(orderIdxList == null || orderIdxList.isEmpty()) {
			return 0;
		}
		return outboundMapper.updateStatusReady(orderIdxList);
	}
    
    // 출고 상태 변경(출고준비 -> 배차대기)
    @Transactional
    @WorkingLog(target = WorkingLogTarget.OUTBOUND_ORDER)
	public int updateStatusDispatchWait(String obwaitNumber, Long outboundOrderIdx) {
//		if(obwaitNumber == null || obwaitNumber.isBlank() || outboundOrderIdx == null) {
//			return 0;
//		}
		return outboundMapper.updateStatusDispatchWait(obwaitNumber.trim(), outboundOrderIdx);
	}
}
