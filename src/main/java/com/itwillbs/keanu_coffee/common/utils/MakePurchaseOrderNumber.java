package com.itwillbs.keanu_coffee.common.utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;

import com.itwillbs.keanu_coffee.common.service.PurchaseOrderService;

public class MakePurchaseOrderNumber {
	
	
	public MakePurchaseOrderNumber(PurchaseOrderService purchaseOrderService) {
		this.purchaseOrderService = purchaseOrderService;
	}

	@Autowired
	private PurchaseOrderService purchaseOrderService;
	
	public String MakePurchaseOrderNo() {
	//make purchase order number using correct format
			LocalDate now = LocalDate.now();
			int compactDate = Integer.parseInt(now.format(DateTimeFormatter.ofPattern("yyyyMMdd")));

		    
		    
		    
//		    String lastPOToday = purchaseOrderService.getTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber();
//		    
//		    String lastThreePONo = "";
//
//			//creating new last three numbers
//		    if(lastPOToday == null || lastPOToday.isEmpty()) {
//			    	 lastThreePONo = "-001";	 
//			    } else {
//			    	   lastThreePONo = lastPOToday.length() >= 3
//			    		        ? lastPOToday.substring(lastPOToday.length() - 3)
//		    		        : ""; // fallback if shorter than 3 chars
//		
//			    	 lastThreePONo = lastPOToday.substring(lastPOToday.length() - 3);
//			    	int number = Integer.parseInt(lastThreePONo); 
//			    	number++; 
//		
//		//	    	 Format back to 3 digits with leading zeros
//		    	lastThreePONo = "-" + String.format("%03d", number); 
//			    }
//		    
//			    String purchaseOrderNumber = "PO" + formattedTimestamp + lastThreePONo;
//			    
//			    return purchaseOrderNumber;
//	}
		    String lastPOToday = purchaseOrderService.getTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber();

		    String lastThreePONo;
		    if (lastPOToday == null || lastPOToday.length() < 3) {
		        // No previous PO or too short to extract number
		        lastThreePONo = "-001";
		    } else {
		        try {
		            String lastThreeDigits = lastPOToday.substring(lastPOToday.length() - 3);
		            int number = Integer.parseInt(lastThreeDigits);
		            number++;
		            lastThreePONo = "-" + String.format("%03d", number);
		        } catch (NumberFormatException e) {
		            // Fallback in case the last 3 characters aren't numeric
		            lastThreePONo = "-001";
		        }
		    }

		    String purchaseOrderNumber = "PO-" + compactDate + lastThreePONo;
		    return purchaseOrderNumber;
	}
			    
}
