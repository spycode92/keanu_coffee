package com.itwillbs.keanu_coffee.inventory.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.itwillbs.keanu_coffee.inventory.service.InventorySchedulerService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class InventoryScheduler {
	private final InventorySchedulerService inventorySchedulerService;
	
	// 임박 재고 조회 (매일 새벽 3시에 실행)
    @Scheduled(cron = "0 0 3 * * *")
    public void runImminentStockCheck() {
    	
        System.out.println("⏰ [Scheduler] 임박 재고 체크 실행");
        
        inventorySchedulerService.getImminentStock();  
    }
	
}
