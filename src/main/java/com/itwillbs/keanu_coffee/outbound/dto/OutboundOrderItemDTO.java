package com.itwillbs.keanu_coffee.outbound.dto;

import lombok.Data;

@Data
public class OutboundOrderItemDTO {
	private Integer outboundOrderItemIdx;
	private Integer outboundOrderIdx;   // 출고주문 idx
	private Integer productIdx;         // 상품 idx
	private String receiptProductIdx;   // 입고상품 idx
	private Integer quantity;           // 주문수량
}
