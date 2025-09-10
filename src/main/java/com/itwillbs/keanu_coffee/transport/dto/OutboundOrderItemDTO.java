package com.itwillbs.keanu_coffee.transport.dto;

import lombok.Data;

@Data
public class OutboundOrderItemDTO {
	private Integer outboundOrderItemIdx;
	private Integer outboundOrderIdx;   // 출고주문 idx
	private Integer productIdx;         // 상품 idx
	private String receiptProductIdx;   // 입고상품 idx
	private Integer quantity;           // 주문수량
	private String productName;         // 상품 이름
    private Integer productVolume;      // 박스 규격 (부피 단위)
}
