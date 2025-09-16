package com.itwillbs.keanu_coffee.inventory.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.itwillbs.keanu_coffee.inventory.service.InventorySchedulerService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class InventoryScheduler {
	private final InventorySchedulerService inventorySchedulerService;
	
	/*
	 	0 → 초 = 0초 정각
		30 → 분 = 30분
		0 → 시 = 0시 (자정)
		* → 일 = 매일
		* → 월 = 매월
		* → 요일 = 요일 무관
	 */
	
	// 임박 재고 조회 (매일 00시 30분(= 밤 12시 반))
//	@Scheduled(cron = "0 30 0 * * *")
	@Scheduled(cron = "0 16 19 * * *")
    public void runImminentStockCheck() {
        System.out.println("⏰ [Scheduler] 임박 + 만료 재고 체크 실행");
        
        // 임박 재고 알림 처리
        inventorySchedulerService.getImminentStock();
        
        // 만료 재고 확인
        inventorySchedulerService.selectExpiredStock();

    }
	
}
