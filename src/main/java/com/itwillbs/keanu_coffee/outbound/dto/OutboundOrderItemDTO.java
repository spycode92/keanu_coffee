package com.itwillbs.keanu_coffee.outbound.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OutboundOrderItemDTO {

    // PK
    private Integer outboundOrderItemIdx; // 출고 품목 idx

    private Integer outboundOrderIdx;     // 출고주문 idx (상위 PK 참조)

    // 품목 정보
    private Integer productIdx;           // 제품 idx
    private String  receiptProductIdx;    // 입고(검수/접수)에서 넘어온 제품 식별 (문자열)
    private Integer quantity;             // 수량

	private String note;
}
