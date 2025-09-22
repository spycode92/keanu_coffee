package com.itwillbs.keanu_coffee.inventory.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.itwillbs.keanu_coffee.inventory.service.InventorySchedulerService;
import com.itwillbs.keanu_coffee.inventory.service.InventoryTransferService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class InventoryScheduler {
	private final InventorySchedulerService inventorySchedulerService;
	private final InventoryTransferService inventoryTransferService;
	
	/*
	 	0 → 초 = 0초 정각
		30 → 분 = 30분
		0 → 시 = 0시 (자정)
		* → 일 = 매일
		* → 월 = 매월
		* → 요일 = 요일 무관
	 */
	
	// 임박 재고 조회 (매일 00시 30분(= 밤 12시 반))
	@Scheduled(cron = "0 30 0 * * *")
//	@Scheduled(cron = "0 16 19 * * *")
    public void runImminentStockCheck() {
        System.out.println("⏰ [Scheduler] 임박 + 만료 재고 체크 실행");
        
        // 임박 재고 알림 처리
        inventorySchedulerService.getImminentStock();
        
    }
	
	// 기준 계산 (일주일에 1번, 일요일 새벽 1시)
	// 최근 7일 출고량 → 하루 평균 → ×2 → targetStockCache 저장
	@Scheduled(cron = "0 0 1 * * SUN")
	// 기준 계산 (테스트용: 30초마다 실행)
//	 @Scheduled(cron = "*/30 * * * * *")
	public void updateTargetStock() {
	    System.out.println("⏰ [Scheduler] 적정재고 기준 갱신 (주 1회)");
	    inventoryTransferService.updatePickingZoneTargetStock();
	}

	// 검사 (매일 새벽 1시)
	// 저장된 targetStockCache 기준 vs 현재 INVENTORY 비교 → 보충 필요 대상 산출
	@Scheduled(cron = "0 0 1 * * *")
	// 검사 (테스트용: 30초마다 실행)
//	 @Scheduled(cron = "*/30 * * * * *")
	public void checkReplenishment() {
	    System.out.println("⏰ [Scheduler] 피킹존 보충 검사 (매일)");
	    inventoryTransferService.checkPickingZoneNeedsReplenishment();
	}
	
}
