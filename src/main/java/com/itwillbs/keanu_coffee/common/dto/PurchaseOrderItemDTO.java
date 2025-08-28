package com.itwillbs.keanu_coffee.common.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PurchaseOrderItemDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
    private Integer orderItemIdx;   // order_item_idx (PK)
    private Integer orderIdx;       // order_idx (FK)
    private Integer productIdx;     // product_idx (FK)
    private Integer quantity;       // quantity
    private BigDecimal unitPrice;   // unit_price (금액은 BigDecimal 권장)
    private BigDecimal totalPrice;  // total_price (quantity * unitPrice)

}
