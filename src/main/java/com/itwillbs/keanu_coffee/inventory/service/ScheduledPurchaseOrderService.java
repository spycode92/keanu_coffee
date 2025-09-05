package com.itwillbs.keanu_coffee.inventory.service;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class ScheduledPurchaseOrderService {
	
	
	@Scheduled(cron = "0 0 * * * ?") // scheduled to check inventory to make orders once an hour
    public void runHourlyInventoryCheck() {
        // Call your controller logic here, or better yet, move it into this service
		
		
        System.out.println("Running daily task");
    }


	
}
