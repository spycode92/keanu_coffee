package com.itwillbs.keanu_coffee.inventory.dto;

import java.sql.Date;
import java.sql.Timestamp;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SupplierProductContractDTO {
	public int supplyContractIdx;
	public int supplierIdx;
	public int productIdx;
	public int contractPrice;
	public Date contractStart;
	public Date contractEnd;
	public int minOrderQuantity;
	public int maxOrderQuantity;
	public String status;
	public String text;
	public Timestamp createdAt;
	public Timestamp updatedAt;
	
	// need this constructor for purchase orders
	public SupplierProductContractDTO(int productIdx, int minOrderQuantity, int maxOrderQuantity) {
		this.productIdx = productIdx;
		this.minOrderQuantity = minOrderQuantity;
		this.maxOrderQuantity = maxOrderQuantity;
	}

	public SupplierProductContractDTO(int supplierIdx, int productIdx) {
		this.productIdx = productIdx;
		this.supplierIdx = supplierIdx;
	}
	
	
	
	
}
