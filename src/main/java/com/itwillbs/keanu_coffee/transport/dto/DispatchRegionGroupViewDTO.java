package com.itwillbs.keanu_coffee.transport.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;

import lombok.Data;

@Data
public class DispatchRegionGroupViewDTO {
	private Integer outboundOrderIdx; // 출고주문 idx
	private Integer regionIdx;        // 구역 idx
	private String regionName;        // 구역 이름
	private Timestamp dispatchDate;   // 출고일자
	private String startSlot;         // 출발 시간
	private Integer franchiseIdx;     // 지점 idx
	private String franchiseName;     // 지점 이름
	private char urgentFlag;          // 긴급 여부
	private String status;            // 주문 상태
	
	// 지점별 세부 상품 리스트
	private List<OutboundOrderItemDTO> items;
	
	// 집계
	private BigDecimal totalVolume;   // 총 적재 부피
	private Integer totalQty;         // 총 수량
	
}
