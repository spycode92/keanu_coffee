package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OutboundOrderItem {
    private int outboundOrderItemIdx;
    private int outboundOrderIdx;
    private int productIdx;
    private String receiptProductIdx;
    private int quantity;
}
