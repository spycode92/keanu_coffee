package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GeneratePurchaseOrderDTO {
	private String orderNumber;
	private String productName;
	private int productQuantity;
	private int unitPrice;
	
	
}
