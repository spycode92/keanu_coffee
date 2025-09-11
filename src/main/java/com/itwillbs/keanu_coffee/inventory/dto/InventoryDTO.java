package com.itwillbs.keanu_coffee.inventory.dto;

import java.sql.Date;
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

//updated inventory table

//inventory_idx	int
//receipt_product_idx	int
//location_idx	int
//location_name	varchar(50)
//product_idx	int
//quantity	int
//lot_number	varchar(50)
//manufacture_date	date
//expiration_date	date
//created_at	timestamp
//updated_at	timestamp

@Getter
@Setter
@ToString
public class InventoryDTO {
	private String inventoryIdx;
	private int receiptProductIdx;
	private int locationIdx;
	private String locationName;
	private int productIdx;
	private int quantity;
	private String lotNumber;
	private Date manufactureDate;
	private Date expirationDate;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	
}
