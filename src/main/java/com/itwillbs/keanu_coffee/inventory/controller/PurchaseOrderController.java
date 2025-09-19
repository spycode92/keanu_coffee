package com.itwillbs.keanu_coffee.inventory.controller;


import java.io.File;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itextpdf.io.exceptions.IOException;
import com.itwillbs.keanu_coffee.common.service.PurchaseOrderService;
import com.itwillbs.keanu_coffee.common.utils.MakePurchaseOrderNumber;
import com.itwillbs.keanu_coffee.inventory.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.inventory.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.inventory.service.PurchaseOrderGenerator;
import com.itwillbs.keanu_coffee.inventory.service.ScheduledPurchaseOrderService;

//if you want auto order enabled uncomment @EnableScheduling
//@EnableScheduling
@Controller
@RequestMapping("inventoryProductOrder")
public class PurchaseOrderController {
	
//	formula for determining what items to order
	
//	forecasting will be for one week in advance and stock should be enough for the entire week
//	Reorder Quantity = (Forecasted Demand) + (Safety Stock - **limited warehouse space (not going to consider this now)) - (Current Inventory + purchase orders) +- supplier contract 
//	Reorder Quantity = Forecasted Demand + Safety Stock - (Current Inventory + purchase orders) +- supplier contract 
	
	
	
//	Safety stock
//	Safety Stock = Z × σ × √LT
//	- Z = Service level factor (2.33, this means that the supply will be enough 99% of the time)
	
//		it would be better to find the standard deviation of forecasting error here 
//	- σ = Standard deviation of demand per time
//	- √LT = square root of lead time
	
	double serviceLevelFactor = 2.33;
//	√7  - 7days of lead time
	double squareRootOfLeadTime = 2.65;
	

//	lead time for items = 7 days -- all items 7 days for now
	
	
//	Forecasted Demand algorithm
//	Forecast = (alpha * Previous Month's Demand) + (beta * Previous Month's Demand 
//	- Same Month Last Year) ** not doing gamma+ (gamma * Next Month Last Year)
	
//	- Use higher alpha for fast-moving perishables (e.g., α = 0.5–0.7)
//	- Use lower beta if trends are stable (e.g., β = 0.1–0.2)
//	- Use moderate gamma for seasonal items (e.g., γ = 0.3–0.5)
	
	
//	using com.itextpdf package to make product orders into a pdf

	


//	service for making pdf
//	@Autowired
//	private PurchaseOrderGenerator purchaseOrderGenerator;
	
	@Autowired
	private PurchaseOrderService purchaseOrderService;

//	@GetMapping("/trigger")
//	public void triggerManually() throws IOException {
	@Scheduled(cron = "0 0 0 * * *") // every day
//	@Scheduled(cron = "0 * * * * *") // every minute
	public void triggerAutomatically() throws IOException {
	    // your logic here
	
//        scheduledProductOrderService.runHourlyInventoryCheck();
        
//        order forecasting       - the alpha will tell us if demand has been increasing compared to the past             - beta will tell us what to expect for the day based on last year
//    	Forecast = (alpha * (Previous Month's  average daily Demand / Previous Month's  average daily Demand a year ago) + (beta * Same day Last Year)  **do gamma later+ (gamma * Same day Last 5 years)
        
 //       주문 예측 - 알파가 과거에 비해 수요가 증가했는지 알려줍니다 - 베타가 작년을 기준으로 하루 동안 무엇을 기대해야 하는지 알려줍니다
//      예측 = (alpha * (전월 평균 일일 수요 / 1년 전 전월 평균 일일 수요) + (beta * 작년 같은 날) **gamma later + (gamma * 지난 5년 같은 날)
        
        
//        making alpha bigger means we think that recent demand compared to the past is more important when forecasting
//        making beta bigger means we think that last years demand is more important when forecasting
        
    	double alpha = 0.4; 
    	double beta  = 0.6;
//     ** - gamma .2
    	
    	//create a list of alpha values       
        //get Previous Month's  average daily Demand
        LocalDate today = LocalDate.now();
        YearMonth lastMonth = YearMonth.from(today.minusMonths(1));
        YearMonth lastMonth2 = YearMonth.from(today.minusYears(1));
        int month = lastMonth.getMonthValue();
        int year = lastMonth.getYear();
        int daysInLastMonth = lastMonth.lengthOfMonth();
        int daysInLastMonth21 = lastMonth2.lengthOfMonth();
        
//        retreive product demand from last month and last month a year ago
        List<OutboundOrderItemDTO> lastMonthsDemandItems = purchaseOrderService.getLastMonthsDemand(month, year, daysInLastMonth);
        
        List<OutboundOrderItemDTO> lastMonthsDemandItemsYearAgo = purchaseOrderService.getLastMonthsDemandYearAgo((month), (year - 1), daysInLastMonth21);
        
//        System.out.println("list of average demand for last month's items per day : " + lastMonthsDemandItems);
        
        //divide last month by last month a year ago
        Map<Integer, Double> denominatorMap = lastMonthsDemandItemsYearAgo.stream()
                .collect(Collectors.toMap(OutboundOrderItemDTO::getProductIdx, OutboundOrderItemDTO::getQuantity));

            List<OutboundOrderItemDTO> alphaValuesList = new ArrayList<>();

            for (OutboundOrderItemDTO dtoA : lastMonthsDemandItems) {
                int productIdx = dtoA.getProductIdx();
                double numerator = dtoA.getQuantity();
                double denominator = denominatorMap.getOrDefault(productIdx, 0.0);
                
//                dividing each items demand last month by the demand one year ago and then multiplying that value times 7 to get demand for one week
//                and then multiplying that value times the alpha to create the weight of this value when forecasting
                double quantity = (denominator != 0.0) ? (numerator / denominator) * 7 * alpha : 0.0; //divided quantity

                alphaValuesList.add(new OutboundOrderItemDTO(productIdx, quantity));
            }
//            for (OutboundOrderItemDTO product : alphaValuesList) {
//				System.out.println("product idx : " + product.getProductIdx() + "quantity : " + product.getQuantity());
//			}



//		create a list of beta values
//        retreive product demand from the same week a year ago
//            LocalDate today = LocalDate.now();
            LocalDate oneYearAgo = today.minusYears(1);
            
//            int lastYear = oneYearAgo.getYear();
//            int lastYearMonth = oneYearAgo.getMonthValue();
//            int lastYearDay = oneYearAgo.getDayOfMonth() + 7;
            LocalDate startDate = oneYearAgo.plusDays(7);
            LocalDate endDate = oneYearAgo.plusDays(13); // 7-day window

            
            // sums demand for a year a week ago and then divides by 7
//            List<OutboundOrderItemDTO> betaValuesList = purchaseOrderService.getAvgDemandSameWeekOneYearAgo(lastYear, lastYearMonth, lastYearDay, beta);
            List<OutboundOrderItemDTO> betaValuesList = purchaseOrderService.getAvgDemandSameWeekOneYearAgo(startDate, endDate, beta);
         
//            for (OutboundOrderItemDTO product : betaValuesList) {
//				System.out.println("product idx : " + product.getProductIdx() + "quantity : " + product.getQuantity());
//			}
            
            
            
                   
//         sum alpha and beta list values together for each inventory item
            
            
          
            Map<Integer, Double> quantityMap = new HashMap<>();

            // Combine both lists
            Stream.concat(alphaValuesList.stream(), betaValuesList.stream())
                .forEach(dto -> quantityMap.merge(dto.getProductIdx(), dto.getQuantity(), Double::sum));

            // Convert map back to List<Dto>
            List<OutboundOrderItemDTO> inventoryNeededForWholeWeekSevenDaysLater = quantityMap.entrySet().stream()
            																		.map(entry -> new OutboundOrderItemDTO(entry.getKey(), entry.getValue()))
            																		.collect(Collectors.toList());
        
        

            
            
            
//                start calculating safety stock for two weeks later: 
            	
//                calculate standard deviation of demand using data from last month
            
//                list of demand every day for every item last month
            List<OutboundOrderItemDTO> lastMonthsDemandItemsEveryDay = purchaseOrderService.getLastMonthsDemandItemsEveryDay(month, year);
            

            // Group by idx
            Map<Integer, List<Double>> groupedByIdx = lastMonthsDemandItemsEveryDay.stream()
                .collect(Collectors.groupingBy(
                		OutboundOrderItemDTO::getProductIdx,
                    Collectors.mapping(OutboundOrderItemDTO::getQuantity, Collectors.toList())
                ));

            // Compute standard deviation for each group of product_idx's
            Map<Integer, Double> desiredListOfQuantitiyWithSafetyStockConsideredMap = new HashMap<>();

            for (Map.Entry<Integer, List<Double>> entry : groupedByIdx.entrySet()) {
                List<Double> quantities = entry.getValue();
                double mean = quantities.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
                double variance = quantities.stream()
                    .mapToDouble(q -> Math.pow(q - mean, 2))
                    .average()
                    .orElse(0.0);
                double stdDev = Math.sqrt(variance);
                double finalDesiredQuantity = stdDev * serviceLevelFactor * squareRootOfLeadTime;
                desiredListOfQuantitiyWithSafetyStockConsideredMap.put(entry.getKey(), finalDesiredQuantity);
            }
            List<OutboundOrderItemDTO> desiredListOfQuantitiyWithSafetyStockConsidered = desiredListOfQuantitiyWithSafetyStockConsideredMap.entrySet().stream()
						.map(entry -> new OutboundOrderItemDTO(entry.getKey(), entry.getValue()))
						.collect(Collectors.toList());

            

             
             
             // percent of warehouse volume currently being used
//             double pctWarehouseUsed = purchaseOrderService.getPercentOfWarehouseUsed();
             
//             double 
             
             
             
   // get sum of inventory plus inbound waiting items
             List<OutboundOrderItemDTO> inventoryQuantity = purchaseOrderService.getInventoryQuantity();
             List<OutboundOrderItemDTO> inboundWaitingQuantity = purchaseOrderService.getInboundWaitingQuantity();  //*********** how can I know if inbound has arrived?
            
             // add these two lists together
             Map<Integer, Double> quantityMap2 = new HashMap<>();
//             System.out.println("**************************Inbound waiting quantities: " + inboundWaitingQuantity);
             // Combine both lists
             Stream.concat(inventoryQuantity.stream(), inboundWaitingQuantity.stream())
                 .forEach(dto -> quantityMap2.merge(dto.getProductIdx(), dto.getQuantity(), Double::sum));


             // Convert map back to List<Dto>
             List<OutboundOrderItemDTO> inventoryPlusInboundQty = quantityMap2.entrySet().stream()
             																		.map(entry -> new OutboundOrderItemDTO(entry.getKey(), entry.getValue()))
             																		.collect(Collectors.toList());
             

             // sum safety stock with forecasted demand for 7 days later and then subtract inventory and inbound
             
             Map<Integer, Double> quantityMap3 = new HashMap<>();
             
             // Combine both lists
             Stream.concat(inventoryNeededForWholeWeekSevenDaysLater.stream(), desiredListOfQuantitiyWithSafetyStockConsidered.stream())
             .forEach(dto -> quantityMap3.merge(dto.getProductIdx(), dto.getQuantity(), Double::sum));
             
          // Subtract current inventory plus inbound quantities
             inventoryPlusInboundQty.forEach(dto ->
                 quantityMap3.merge(dto.getProductIdx(), -dto.getQuantity(), Double::sum)
             );

             
             // Convert map back to List<Dto>
             List<OutboundOrderItemDTO> safetyStockPlusForecastedDemandMinusInventory = quantityMap3.entrySet().stream()
            		 .map(entry -> new OutboundOrderItemDTO(entry.getKey(), entry.getValue()))
            		 .collect(Collectors.toList());
             
                
                
             // get contracts for each item that needs to be ordered
             List<SupplierProductContractDTO> contractMinMaxList = purchaseOrderService.getcontracts();
             

// adjust product order based on the minimum and maximum ammounts in the supplier contracts
             List<OutboundOrderItemDTO> adjustedOrders = safetyStockPlusForecastedDemandMinusInventory.stream()
            		    .map(order -> {
            		        Optional<SupplierProductContractDTO> constraintOpt = contractMinMaxList.stream()
            		            .filter(c -> c.getProductIdx() == order.getProductIdx())
            		            .findFirst();

            		        Double adjustedQuantity = constraintOpt.map(constraint ->
            	            Math.max(
            	                constraint.getMinOrderQuantity(),
            	                Math.min(order.getQuantity(), constraint.getMaxOrderQuantity())
            	            )
            	        ).orElse(order.getQuantity()); // Keep original quantity if n

        		            OutboundOrderItemDTO adjustedOrder = new OutboundOrderItemDTO();
        		            adjustedOrder.setProductIdx(order.getProductIdx());
        		            adjustedOrder.setQuantity(adjustedQuantity);
        		            return adjustedOrder;
        		        })
            		    .collect(Collectors.toList());
   
             
 // check if there is any product that has at least one item that needs to be ordered
         boolean hasValidOrder = adjustedOrders.stream()
        		    .anyMatch(order -> order.getQuantity() > 0);
        
        
           
        
//  order creation
         
         
       if(hasValidOrder) {
//    	   remove any items that are less than 1
    	   List<OutboundOrderItemDTO> finalOrders = adjustedOrders.stream()
    			    .filter(order -> order.getQuantity() > 0)
    			    .collect(Collectors.toList());
    	   
    	   

	    
		    
// get supplier info to prepare orders
    	   
		    //get supplier for each product
		    List<SupplierProductContractDTO> productAndSuppplier = purchaseOrderService.getProductAndSuppplier();
		    // change the dto to a map 
//		    Map<Integer, Integer> productAndSuppplierToMap = productAndSuppplier.stream()
//		    	    .collect(Collectors.toMap(
//		    	    		SupplierProductContractDTO::getProductIdx,
//		    	    		SupplierProductContractDTO::getSupplierIdx
//		    	    		SupplierProductContractDTO::getContractPrice
//		    	    ));
		    Map<Integer, SupplierProductContractDTO> productToContractMap = productAndSuppplier.stream()
		    	    .collect(Collectors.toMap(
		    	        SupplierProductContractDTO::getProductIdx,
		    	        Function.identity() // use the whole DTO as the value
		    	    ));
		    
		    
//		    make a list of orders that need to be made organized by supplier
//		    Map<Integer, List<OutboundOrderItemDTO>> ordersBySupplier = finalOrders.stream()
//		    	    .collect(Collectors.groupingBy(order -> 
//		    	    productAndSuppplierToMap.getOrDefault(order.getProductIdx(), -1) // -1 for unknown supplier
//		    	    ));
		    Map<Integer, List<OutboundOrderItemDTO>> ordersBySupplier = finalOrders.stream()
		    	    .collect(Collectors.groupingBy(order -> {
		    	        SupplierProductContractDTO contract = productToContractMap.get(order.getProductIdx());
		    	        return (contract != null) ? contract.getSupplierIdx() : -1;
		    	    }));
		    
		    Map<Integer, Integer> productToContractPriceMap = productAndSuppplier.stream()
		    	    .collect(Collectors.toMap(
		    	        SupplierProductContractDTO::getProductIdx,
		    	        SupplierProductContractDTO::getContractPrice
		    	    ));
		    
		    
		    // get purchase order number by calling method from common/utils/MakePurchaseOrderNumber
//		    MakePurchaseOrderNumber mpon = new MakePurchaseOrderNumber();
//		    String purchaseOrderNumber = mpon.MakePurchaseOrderNo();
//		    LocalDateTime now = LocalDateTime.now();
//		    
//		    
////		    print for testing
//		    ordersBySupplier.forEach((supplierId, orders) -> {
//		        System.out.println("Supplier " + supplierId + ":");
//		        orders.forEach(order -> 
//		            System.out.println("  Product " + order.getProductIdx() + ", Qty " + order.getQuantity());
//		            purchaseOrderService.addProductOrder(purchaseOrderNumber, supplierId, "auto_generated_order", now);
//		            purchaseOrderService.addProductOrderItem(purchaseOrderNumber, order.getProductIdx(), order.getQuantity());
//		        );
//		    });

		    ordersBySupplier.forEach((supplierId, orders) -> {
//		        System.out.println("Supplier " + supplierId + ":");

		        // Generate a unique PO number per supplier
		        MakePurchaseOrderNumber mpon = new MakePurchaseOrderNumber(purchaseOrderService);
		        String purchaseOrderNumber = mpon.MakePurchaseOrderNo();
//		        System.out.println(purchaseOrderNumber);
		        LocalDateTime now = LocalDateTime.now();
		        
		        // make order_idx from last 9 digits of purchase order
		        String[] parts = purchaseOrderNumber.split("-");
//		        System.out.println("parts : " + parts);
		        String datePart = parts[1].substring(2);      // "250804"
//		        System.out.println("datePart : " + datePart);
		        String sequencePart = parts[2];               // "001"
//		        System.out.println("sequencePart : " + sequencePart);

		        int orderIdx = Integer.parseInt(datePart + sequencePart); // result: 250804001
//		        String[] parts = purchaseOrderNumber != null ? purchaseOrderNumber.split("-") : new String[0];
//		        int orderIdx = 0;
//		        String datePart = "";
//		        String sequencePart = "";
//		        if (parts.length >= 3) {
//		            datePart = parts[1].replaceAll("[^0-9]", ""); // strip non-numeric characters
//		            sequencePart = parts[2];
//
//		            String combined = datePart + sequencePart;
//
//		            try {
//		                orderIdx = Integer.parseInt(combined);
//		                // use orderIdx safely
//		            } catch (NumberFormatException e) {
//		                System.err.println("Invalid format for order index: " + combined);
//		                // fallback or throw custom exception
//		            }
//		        } else {
//		            System.err.println("Unexpected purchase order format: " + purchaseOrderNumber);
//		        }
//		        
		        //make inbound waiting number
		        String inboundWaitingNumber = "IBW-20" + datePart + "-" + sequencePart;
		        
		        //count number of different items ordered
		        int numberOfItems = orders.size();
		        
		        //count total number of items ordered 
		        AtomicInteger quantity = new AtomicInteger(0);

		        orders.forEach(order -> {
		            quantity.addAndGet((int)order.getQuantity());
		        });

		        int totalQuantity = quantity.get();
		        
		       //make expectedArrivalDate
		        LocalDate expectedArrivalDate = now.toLocalDate().plusDays(3);
		        
		        // Create the purchase order and inbound waiting order once per supplier
		        purchaseOrderService.addProductOrder(orderIdx, purchaseOrderNumber, supplierId, now, expectedArrivalDate);
		       
		        purchaseOrderService.addInboundWaitingOrder(inboundWaitingNumber, orderIdx, totalQuantity, numberOfItems, expectedArrivalDate);
		        int finalOrderIdx = orderIdx;  // getting error that orderIdx needs to be effectively final
		        // Add all items to that order
		        orders.forEach(order -> {
		        	int contractPrice = productToContractPriceMap.get(order.getProductIdx());
//		            System.out.println("  Product " + order.getProductIdx() + ", Qty " + order.getQuantity());
		            purchaseOrderService.addProductOrderItem(finalOrderIdx, order.getProductIdx(), order.getQuantity(), contractPrice);
		        });
		    });

		    
		    
		    
// make a pdf of product order -- no t
		
//	       String filePath = "temp/purchase_order.pdf";
	//        purchaseOrderGenerator.generatePurchaseOrder("output/purchase_order.pdf");
//	       File file = new File(filePath);
	//       InputStreamResource resource = new InputStreamResource(new FileInputStream(file));
	       
	//       inbound oder waiting also needs to be created
//        return ResponseEntity.ok()
//                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=purchase_order.pdf")
//               .contentType(MediaType.APPLICATION_PDF)               
//               .contentLength(file.length())                
//               .body(resource);
		    
//       return null;

        
	} else {
//		System.out.println("no orders needed");
	}
    }
}
//}
