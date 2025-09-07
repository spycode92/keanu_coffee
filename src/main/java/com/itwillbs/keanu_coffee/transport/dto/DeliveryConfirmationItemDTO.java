package com.itwillbs.keanu_coffee.transport.dto;

import lombok.Data;

@Data
public class DeliveryConfirmationItemDTO {
	private Integer confirmationItemIdx;  // 고유번호
    private Integer confirmationIdx;      // 수주확인서 고유번호
    private Integer productIdx;           // 상품 고유번호
    private String itemName;              // 품목 이름
    private Integer orderedQty;           // 주문 수량
    private Integer deliveredQty;         // 실제 납품 수량
    private String status;                // 납품 상태 (OK, REFUND, PARTIAL_REFUND)
}
