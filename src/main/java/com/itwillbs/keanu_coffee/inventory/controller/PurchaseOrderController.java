package com.itwillbs.keanu_coffee.inventory.controller;


import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.common.service.PurchaseOrderService;
import com.itwillbs.keanu_coffee.inventory.service.PurchaseOrderGenerator;
import com.itwillbs.keanu_coffee.inventory.service.ScheduledPurchaseOrderService;

@Controller
@RequestMapping("inventoryProductOrder")
public class PurchaseOrderController {
	private final ScheduledPurchaseOrderService scheduledProductOrderService;
	
	
	
	
//	formula for determining what items to order
//	Reorder Quantity = (Forecasted Demand × Lead Time) + (Safety Stock - limited warehouse space) - (Current Inventory + purchase orders) +- supplier contract 
	
	
	
//	Safety stock
//	Safety Stock = Z × σ × √LT
//	- Z = Service level factor (2.33, this means that the supply will be enough 99% of the time)
//	- σ = Standard deviation of demand per time
//	- √LT = square root of lead time
	
//	lead time for coffee(imported) = 3 weeks
//	lead time for other items = 7 days -- all items 7 days for now
	
	
//	Forecasted Demand algorithm
//	Forecast = (alpha * Previous Month's Demand) + (beta * Previous Month's Demand 
//	- Same Month Last Year) + (gamma * Next Month Last Year)
	
//	I want to use data model in anaconda scikit learn? to determine the following variables
//	- Use higher alpha for fast-moving perishables (e.g., α = 0.5–0.7)
//	- Use lower beta if trends are stable (e.g., β = 0.1–0.2)
//	- Use moderate gamma for seasonal items (e.g., γ = 0.3–0.5)
	
	
//	using com.itextpdf package to make product orders into a pdf

	
	public PurchaseOrderController(ScheduledPurchaseOrderService scheduledProductOrderService) {
		this.scheduledProductOrderService = scheduledProductOrderService;
	
	}



	@Autowired
	private PurchaseOrderGenerator purchaseOrderGenerator;
	
//	@Autowired
//	private PurchaseOrderService purchaseOrderService;

//	@GetMapping("/trigger")
//	public ResponseEntity<InputStreamResource> triggerManually() throws IOException {
//        scheduledProductOrderService.runHourlyInventoryCheck();
        
//        if(purchase order needed) {
//		LocalDateTime now = LocalDateTime.now();
//	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
//	    String formattedTimestamp = now.format(formatter);
	    
//	    String lastPOToday = purchaseOrderService.getTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber();
	    
//	    String lastThreePONo = "";

		//creating new last three numbers
//	    if(lastPOToday == null || lastPOToday.isEmpty()) {
//	    	 lastThreePONo = "-001";	 
//	    } else {
//	    	   lastThreePONo = lastPOToday.length() >= 3
//	    		        ? lastPOToday.substring(lastPOToday.length() - 3)
//	    		        : ""; // fallback if shorter than 3 chars

//	    	 lastThreePONo = lastPOToday.substring(lastPOToday.length() - 3);
	    	
//	    	int number = Integer.parseInt(lastThreePONo); 
//	    	number++; 

//	    	 Format back to 3 digits with leading zeros
//	    	lastThreePONo = "-" + String.format("%03d", number); 
	    }
	    
//	    String purchaseOrderNumber = "PO" + formattedTimestamp + lastThreePONo;
	    
	    
	    
//	    purchaseOrderService.makeProductOrder(purchaseOrderNumber );
	
	
	
//        String filePath = "temp/purchase_order.pdf";
//        purchaseOrderGenerator.generatePurchaseOrder("output/purchase_order.pdf");
//        File file = new File(filePath);
//        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

        
//		}
//        return ResponseEntity.ok()
//                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=purchase_order.pdf")
//                .contentType(MediaType.APPLICATION_PDF)
//                .contentLength(file.length())
//                .body(resource);

//    }

//}
//}
