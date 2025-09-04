package com.itwillbs.keanu_coffee.common.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PurchaseWithSupplierDTO implements Serializable {
	
	private PurchaseOrderDTO purchaseOrder;
    private SupplierDTO supplier;
    
}
