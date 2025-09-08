package com.itwillbs.keanu_coffee.outbound.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;
import com.itwillbs.keanu_coffee.outbound.mapper.OutboundMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OutboundService {

	private final OutboundMapper outboundMapper;
	
    // 날짜별 3자리 시퀀스 관리를 위한 전용 매퍼

    @Transactional(rollbackFor = Exception.class)
    public int addOutboundOrder(OutboundOrderDTO order, int totalQuantity) {
        // 1) OUTBOUND_ORDER INSERT (PK 채번: useGeneratedKeys 또는 selectKey)
        int inserted = outboundMapper.insertOutboundOrder(order);
        if (inserted <= 0 || order.getOutboundOrderIdx() == null) {
            throw new IllegalStateException("OUTBOUND_ORDER insert failed");
        }
        final Integer orderIdx = order.getOutboundOrderIdx();

        // 2) OUTBOUND_ORDER_ITEM들 INSERT (상위 PK 공유)
        List<OutboundOrderItemDTO> items = order.getItems();
        if (items == null || items.isEmpty()) {
            throw new IllegalStateException("No items to insert");
        }
        int itemCount = 0;
        for (OutboundOrderItemDTO item : items) {
            item.setOutboundOrderIdx(orderIdx);
            // 필요 시 item.setReceiptProductIdx(...); // 입고라인 매칭 로직이 있다면 여기서 세팅
            itemCount += outboundMapper.insertOutboundOrderItem(item);
        }
        if (itemCount != items.size()) {
            throw new IllegalStateException("Some OUTBOUND_ORDER_ITEM rows failed");
        }

        // 3) OUTBOUND_WAITING INSERT (obwait_number: OBYYYYMMDD-XXX 증가)
        String obwaitNumber = nextObwaitNumberWithAdvisoryLock();
        OutboundWaitingDTO waiting = new OutboundWaitingDTO();
        waiting.setObwaitNumber(obwaitNumber);
        waiting.setOutboundOrderIdx(orderIdx);
        waiting.setDepartureDate(LocalDateTime.now());                    // 정책에 맞게 조정
        waiting.setOutboundQuantity(totalQuantity);                     // 총 수량
        waiting.setOutboundClassification(classifyByUrgent(order.getUrgent())); // "긴급"/"일반"
        waiting.setManager(null);
        waiting.setOutboundLocation(null);
        waiting.setNote(null);
        waiting.setCreatedAt(LocalDateTime.now());
        waiting.setUpdatedAt(LocalDateTime.now());

        int w = outboundMapper.insertOutboundWaiting(waiting);
        if (w <= 0) throw new IllegalStateException("OUTBOUND_WAITING insert failed");

        return 1;
    }

    private String classifyByUrgent(String urgent) {
        return "Y".equalsIgnoreCase(urgent) ? "긴급" : "일반";
    }
    
    private String nextObwaitNumberWithAdvisoryLock() {
        String dateStr = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE); // YYYYMMDD
        String lockName = "OBWAIT_" + dateStr;

        // 잠금 획득(최대 5초 대기)
        Integer locked = outboundMapper.getLock(lockName, 5);
        if (locked == null || locked != 1) {
            throw new IllegalStateException("Failed to acquire lock for obwait number");
        }

        try {
            Integer maxSuffix = outboundMapper.selectMaxSuffixForDate(dateStr); // null이면 0 취급
            int next = (maxSuffix == null ? 0 : maxSuffix) + 1;
            String suffix = String.format("%03d", next); // 3자리 zero-padding
            return "OB" + dateStr + "-" + suffix;
        } finally {
        	outboundMapper.releaseLock(lockName);
        }
    }
}
