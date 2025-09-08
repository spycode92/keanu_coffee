package com.itwillbs.keanu_coffee.outbound.dto;

import lombok.Data;

@Data
public class OutboundManagementDTO {
    private String obwaitNumber;     // 출고번호 (OUTBOUND_WAITING.obwait_number)
    private String outboundDate;     // 출고일자 (OUTBOUND_WAITING.arrival_date)
    private String outboundLocation; // 출고위치 (OUTBOUND_WAITING.outbound_location)
    private Integer franchiseIdx;    // 주문프렌차이즈 (OUTBOUND_ORDER.franchise_idx)
    private String status;           // 상태 (OUTBOUND_ORDER.status)
    private Integer itemCount;       // 품목수 (COUNT)
    private Integer totalQuantity;   // 출고예정수량 (SUM)
    private String manager;          // 담당자 (OUTBOUND_WAITING.manager)
    private String note;             // 비고 (OUTBOUND_WAITING.note)
}

