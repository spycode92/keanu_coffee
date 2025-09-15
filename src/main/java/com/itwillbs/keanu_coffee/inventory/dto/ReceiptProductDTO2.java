package com.itwillbs.keanu_coffee.inventory.dto;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
//receipt_product_idx	int
//ibwait_idx	int
//supplier_idx	int
//product_idx	int
//lot_number	varchar(50)
//manufacture_date	date
//expiration_date	date
//quantity	int
//received_at	timestamp
//emp_idx	int
//created_at	timestamp
//updated_at	timestamp


@Getter
@Setter
@ToString
public class ReceiptProductDTO2 {
	private int receiptProductIdx;
	private int ibwaitIdx;
	private int supplierIdx;
	private int productIdx;
	private String lotNumber;
	private Date manufactureDate;
	private Date expirationDate;
	private int quantity;
	private Timestamp receivedAt;
	private int empIdx;
	private Timestamp createdAt;
	private Timestamp updatedAt;

}
