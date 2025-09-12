package com.itwillbs.keanu_coffee.outbound.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class OutboundProductDetailDTO {
	private int obwaitIdx;              	
    private String obwaitNumber;        	
    private LocalDateTime departureDate;  	
    private String orderNumber;         	
    private String outboundClassification; 	
    private String supplierName;         	
    private String manager;          	
    private String outboundLocation;      	
    private String outboundStatus;		 	
    private int numberOfItems;           	
    private int quantity;                
    private String note;             
    
    private Integer productIdx;     // p.product_idx
    private String productName;     // p.product_name
    private String productVolume;   // p.product_volume
    private String lotNumber;  
}

