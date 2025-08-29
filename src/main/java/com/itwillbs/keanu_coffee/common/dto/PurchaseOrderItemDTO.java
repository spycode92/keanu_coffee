package com.itwillbs.keanu_coffee.common.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PurchaseOrderItemDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private Integer orderItemIdx;   // order_item_idx (PK)
    private Integer orderIdx;       // order_idx (FK)
    private Integer productIdx;     // product_idx (FK)
    private Integer quantity;       // quantity 갯수
    private BigDecimal unitPrice;   // unit_price 가격
    private BigDecimal totalPrice;  // total_price (quantity * unitPrice)
    
}

