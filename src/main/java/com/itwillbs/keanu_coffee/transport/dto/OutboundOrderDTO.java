package com.itwillbs.keanu_coffee.transport.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

@Data
public class OutboundOrderDTO {
	private Integer outboundOrderIdx;
	private Integer franchiseIdx; // 가맹정 idx
	private String status;
	private char urgent; // 기본 N 
	private LocalDateTime  expectOutboundDate; // 출고가능일
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	
	// 상세 항목 리스트
	private List<OutboundOrderItemDTO> items;
}
