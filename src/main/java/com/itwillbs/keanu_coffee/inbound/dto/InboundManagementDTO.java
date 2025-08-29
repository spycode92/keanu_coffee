package com.itwillbs.keanu_coffee.inbound.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class InboundManagementDTO {
	
	private String orderNumber;
	private LocalDate expectedArrivalDate;
	private String supplierName;

	private Integer totalItemCount;
	private Long totalPlannedQty;
	
}
	