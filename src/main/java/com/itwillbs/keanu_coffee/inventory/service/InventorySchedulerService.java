package com.itwillbs.keanu_coffee.inventory.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.common.dto.AlarmDTO;
import com.itwillbs.keanu_coffee.common.service.AlarmService;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventorySchedulerMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InventorySchedulerService {
	private final InventorySchedulerMapper inventorySchedulerMapper;
	private final SimpMessagingTemplate messagingTemplate;
	private final AlarmService alarmService;
	
	// 임박 재고 조회 + 알림 처리
    public void getImminentStock() {
        List<InventoryDTO> imminentList = inventorySchedulerMapper.selectImminentStock();
        
        for (InventoryDTO item : imminentList) {

            // 알림 메시지
            String msg = "상품코드:" + item.getProductIdx()
                       + " (LOT:" + (item.getLotNumber() == null ? "–" : item.getLotNumber()) + ")"
                       + " 유통기한 임박 (" + item.getExpirationDate() + ")";

            // 알림 객체 생성
            AlarmDTO alarm = new AlarmDTO();
            alarm.setEmpIdx(11);  // 재고담당자
            alarm.setRoleName("재고관리자");
            alarm.setEmpAlarmMessage(msg);

            // DB 저장
        	alarmService.insertAlarmByRole(alarm);

            // 웹소켓 전송
            Map<String, String> payload = new HashMap<>();
            payload.put("message", alarm.getEmpAlarmMessage());
            messagingTemplate.convertAndSend("/topic/" + alarm.getRoleName(), payload);
        }
    }
    
	// ❌ 만료 재고 알림은 하지 않음 → 조회 제외 용도만
    // 만료 재고 조회 (조회 제외 용도)
    public List<InventoryDTO> selectExpiredStock() {
        return inventorySchedulerMapper.selectExpiredStock();
    }
    
}
