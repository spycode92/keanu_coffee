package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OutboundOrderItemDTO {
	
//	this constructor is needed for forecasting
    public OutboundOrderItemDTO(int productIdx, double quantity) {
    	this.productIdx = productIdx;
    	this.quantity = quantity;
	}
	private int outboundOrderItemIdx;
    private int outboundOrderIdx;
    private int productIdx;
    private String receiptProductIdx;
    
//    because lots of calculations need to be done to determine what quantity to order, the quantity needs to be a double type in our dto
    private double quantity;
}
