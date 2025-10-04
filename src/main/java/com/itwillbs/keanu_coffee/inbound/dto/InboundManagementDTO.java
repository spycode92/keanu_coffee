package com.itwillbs.keanu_coffee.inbound.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class InboundManagementDTO {
	
	private String orderNumber;           // 발주번호
    private int ibwaitIdx;                // 입고번호
    private String ibwaitNumber;          // 입고번호
    private LocalDateTime arrivalDate;    // 입고일자
    private String arrivalDateStr;		  // 입고일자 문자열 포매팅
    private String supplierName;          // 공급업체명
    private String inboundStatus;         // 입고 상태
    private int numberOfItems;            // 품목수
    private int quantity;                 // 입고예정수량
    private String manager;               // 담당자
    private String note;                  // 비고
	
}
	