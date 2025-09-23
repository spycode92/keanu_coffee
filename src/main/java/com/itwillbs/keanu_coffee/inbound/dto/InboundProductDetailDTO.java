package com.itwillbs.keanu_coffee.inbound.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Date;

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
	 private Date manufactureDate;
	 private Date expirationDate;
}
