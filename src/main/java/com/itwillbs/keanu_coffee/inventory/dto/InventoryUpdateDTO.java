package com.itwillbs.keanu_coffee.inventory.dto;

import lombok.Data;

@Data
public class InventoryUpdateDTO {
	private Integer locationIdx;
	private Integer receiptProductIdx;
	private Integer adjustQuantity;
	private Integer quantity;
	private Boolean isDisposal;
}
