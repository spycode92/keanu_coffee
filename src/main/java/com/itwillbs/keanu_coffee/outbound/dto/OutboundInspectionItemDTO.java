package com.itwillbs.keanu_coffee.outbound.dto;

import lombok.Data;

@Data
public class OutboundInspectionItemDTO {
    private Long outboundOrderItemIdx;   // 출고오더 품목 PK
    private String lotNumber;            // LOT 번호
    private String productName;          // 상품명
    private String productVolume;        // 규격/단위
    private Integer quantity;            // 출고수량
}
