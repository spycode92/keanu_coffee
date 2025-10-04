package com.itwillbs.keanu_coffee.common.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
//@NoArgsConstructor
@AllArgsConstructor
public class PurchaseOrderDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
    private Integer orderIdx;                     // order_idx (PK)
    private String  orderNumber;                  // order_number
    private Integer supplierIdx;                  // supplier_idx (FK)
    private Integer empIdx;                       // emp_idx (FK)
    private LocalDateTime orderDate;              // order_date
    private String  status;                       // status (요청중/요청완료/취소/배송대기/배송완료)
    private LocalDate expectedArrivalDate;        // expected_arrival_date
    private String  note;                         // note
    private LocalDateTime createdAt;              // created_at
    private LocalDateTime updatedAt;              // updated_at
    
    private List<PurchaseOrderItemDTO> items;
    
}
