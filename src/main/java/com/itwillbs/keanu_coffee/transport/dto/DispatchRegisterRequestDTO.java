package com.itwillbs.keanu_coffee.transport.dto;

import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import lombok.Data;

@Data
public class DispatchRegisterRequestDTO {
	private String orderIds;                 // 주문 ID 리스트
	private List<DriverVehicleDTO> drivers;  // 기사/차량 정보 리스트
	private Integer vehicleIdx;       	     // 차량 idx
	private char urgentFlag;          	     // 긴급 여부
	private String status;            	     // 주문 상태
	private Timestamp dispatchDate;   	     // 출고일자
	private String startSlot;         	     // 출발 시간
	
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
