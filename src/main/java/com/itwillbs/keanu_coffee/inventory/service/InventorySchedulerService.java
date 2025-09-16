package com.itwillbs.keanu_coffee.inventory.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
        
        // 중복 방지용 Set (empIdx + message 기준)
        Set<String> uniqueKeys = new HashSet<>();
        
        for (InventoryDTO item : imminentList) {
        	// 오늘 날짜
            LocalDate today = LocalDate.now();

            // 유통기한
            LocalDate expDate = item.getExpirationDate().toLocalDate();

            // 남은 일수 계산
            long remainDays = ChronoUnit.DAYS.between(today, expDate);
            
            // 알림 메시지
            String msg = "상품코드:" + item.getProductIdx() +
                         " (LOT:" + (item.getLotNumber() != null ? item.getLotNumber() : "–") + ")" +
                         " 유통기한 임박 (" + expDate + ", D-" + remainDays + ")";

            // 알림 받을 사람 (재고관리자 empIdx 고정, 예: 11)
            int targetEmpIdx = 11;

            // 중복 체크 키 생성
            String key = "emp:" + targetEmpIdx + "|msg:" + msg;
            if (uniqueKeys.contains(key)) continue; // 이미 있으면 skip
            uniqueKeys.add(key);
            
            // 1. 알림 객체 생성
            AlarmDTO alarm = new AlarmDTO();
            alarm.setEmpIdx(targetEmpIdx);   // 대상자 지정
            alarm.setRoleName("재고관리자");
            alarm.setEmpAlarmMessage(msg);
            
        	// 알람 클릭 시 이동할 링크 → stockCheck.jsp 에서 '임박' 필터 적용
//        	alarm.setEmpAlarmLink("/inventory/stockCheck?stockStatus=WARN");

            // 2. DB 저장
        	alarmService.insertAlarmByRole(alarm);

            // 3. 웹소켓 전송
            Map<String, String> payload = new HashMap<>();
            payload.put("message", alarm.getEmpAlarmMessage());
            messagingTemplate.convertAndSend("/topic/" + alarm.getRoleName(), payload);
        }
    }
    
}
