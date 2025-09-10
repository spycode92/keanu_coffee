package com.itwillbs.keanu_coffee.transport.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;

import lombok.Data;

@Data
public class DispatchRegionGroupViewDTO {
	private Integer outboundOrderIdx;      // 출고주문 idx
	private Integer regionIdx;             // 구역 idx
	private Integer vehicleIdx;       	   // 차량 idx
	private Integer dispatchIdx;           // 배차 idx
	private String regionName;        	   // 구역 이름
	private Timestamp dispatchDate;   	   // 출고일자
	private String startSlot;         	   // 출발 시간
	private char urgent;          	       // 긴급 여부
	private char requiresAdditional;       // 추가배차
	private String status;            	   // 주문 상태
	private String driverName;             // 기사 이름
	private String vehicleNumber;          // 차량 번호
	private Integer capacity;              // 차량 용량
	
	// 지점별 세부 상품 리스트
	private List<OutboundOrderItemDTO> items;
	
	// 주문 ID 리스트
	private String orderIds;
	
	// 집계
	private BigDecimal totalVolume;   // 총 적재 부피
	private Integer totalQty;         // 총 수량
	
	public List<Integer> getOrderList() {
		if (orderIds == null || orderIds.isEmpty()) {
			return List.of();
		}
		
		return Arrays.stream(orderIds.split(","))
					 .map((string) -> {
						 return Integer.valueOf(string);
					 })
					 .collect(Collectors.toList());
	}
	
}
