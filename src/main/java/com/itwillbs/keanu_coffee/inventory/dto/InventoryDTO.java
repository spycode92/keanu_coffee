package com.itwillbs.keanu_coffee.inventory.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

 //TABLE INVENTORY (
//	    lot_number VARCHAR(50) PRIMARY KEY,
//	    location_idx INT(11),
//	    product_idx INT(11),
//	    quantity INT(11),
//	    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
//	    FOREIGN KEY (location_idx) REFERENCES WAREHOUSE_LOCATION(location_idx),
//	    FOREIGN KEY (product_idx) REFERENCES PRODUCT(product_idx)



@Getter
@Setter
@ToString
public class InventoryDTO {
	private String lotNumber;
	private int locationIdx;
	private int productIdx;
	private int quantity;
	private Timestamp updatedAt;
	
}
