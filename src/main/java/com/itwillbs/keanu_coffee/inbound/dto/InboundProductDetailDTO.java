package com.itwillbs.keanu_coffee.inbound.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class InboundProductDetailDTO {
	 private int productIdx;
	 private String lotNumber;
	 private String productName;
	 private int productVolume;
	 private int quantity;
	 private BigDecimal unitPrice;	    
	 private BigDecimal amount;
	 private BigDecimal tax;
	 private BigDecimal totalPrice;
}
