package com.itwillbs.keanu_coffee.outbound.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundManagementDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
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
}
