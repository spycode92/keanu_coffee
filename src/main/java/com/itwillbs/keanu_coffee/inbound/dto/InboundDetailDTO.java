package com.itwillbs.keanu_coffee.inbound.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class InboundDetailDTO {
    private int ibwaitIdx;               // 입고번호
    private LocalDateTime arrivalDate;   // 입고일자
    private String orderNumber;          // 발주번호
    private String inboundClassification; // 입고구분 (발주 기준)
    private String supplierName;         // 공급업체명
    private String managerName;          // 담당자명
    private String inboundLocation;      // 입고위치
    private int numberOfItems;           // 품목수
    private int quantity;                // 총수량
    private BigDecimal totalPrice;              // 청구액 (합계)
    private String note;                 // 비고
}
