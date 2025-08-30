package com.itwillbs.keanu_coffee.inventory.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

 //TABLE INVENTORY (
//inventory_idx int(11) AUTO_INCREMENT PRIMARY KEY,
//receipt_product_idx int(11) ,
//location_idx INT(11),
//quantity INT(11),
//updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
//FOREIGN KEY (location_idx) REFERENCES WAREHOUSE_LOCATION(location_idx),
//FOREIGN KEY (receipt_product_idx) REFERENCES RECEIPT_PRODUCT(receipt_product_idx)



@Getter
@Setter
@ToString
public class InventoryDTO {
	private String inventoryIdx;
	private int receiptProductIdx;
	private int locationIdx;
	private int quantity;
	private Timestamp updatedAt;
	
}
