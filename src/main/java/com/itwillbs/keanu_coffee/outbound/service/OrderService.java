package com.itwillbs.keanu_coffee.outbound.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;
import com.itwillbs.keanu_coffee.outbound.mapper.OrderMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OrderService {
	
	private final OrderMapper orderMapper;
	
	@Transactional(rollbackFor = Exception.class)
	public int addOutboundOrder(OutboundOrderDTO order, int totalQuantity) {
		// 1) OUTBOUND_ORDER INSERT
		int inserted = orderMapper.insertOutboundOrder(order);
		if (inserted <= 0 || order.getOutboundOrderIdx() == null) {
			throw new IllegalStateException("OUTBOUND_ORDER insert failed");
		}
		final Integer orderIdx = order.getOutboundOrderIdx();

		// 2) 각 품목에 대해 FEFO 자동 배분으로 OUTBOUND_ORDER_ITEM 다중행 INSERT
		List<OutboundOrderItemDTO> items = order.getItems();
		if (items == null || items.isEmpty()) {
			throw new IllegalStateException("No items to insert");
		}

		for (OutboundOrderItemDTO item : items) {
			final Integer productIdx = item.getProductIdx();
			final Integer requiredQty = item.getQuantity();
			if (productIdx == null || requiredQty == null || requiredQty <= 0) {
				throw new IllegalArgumentException("Invalid item payload");
			}

			// 제품 단위로 어드바이저리 락(경쟁 출고 대비)
			String lockName = "ALLOC_P" + productIdx;
			Integer locked = orderMapper.getLock(lockName, 5);
			if (locked == null || locked != 1) {
				throw new IllegalStateException("Failed to acquire allocation lock for product " + productIdx);
			}
			try {
				// FEFO 배분 INSERT (여러 로트로 쪼개져 다중 행 삽입 가능)
				int rows = orderMapper.insertOutboundItemsFefo(orderIdx, productIdx, requiredQty);
				if (rows <= 0) {
					throw new IllegalStateException("Allocation failed for product " + productIdx);
				}
			} finally {
				orderMapper.releaseLock(lockName);
			}
		}

		// 3) OUTBOUND_WAITING INSERT (obwait_number 생성)
		String obwaitNumber = nextObwaitNumberWithAdvisoryLock();
		OutboundWaitingDTO waiting = new OutboundWaitingDTO();
		waiting.setObwaitNumber(obwaitNumber);
		waiting.setOutboundOrderIdx(orderIdx);
		waiting.setDepartureDate(LocalDateTime.now());
		waiting.setOutboundQuantity(totalQuantity); // 요청 총수량
		waiting.setOutboundClassification(classifyByUrgent(order.getUrgent())); // "긴급"/"일반"
		waiting.setManager(null);
		waiting.setOutboundLocation(null);
		waiting.setNote(null);
		waiting.setCreatedAt(LocalDateTime.now());
		waiting.setUpdatedAt(LocalDateTime.now());

		int w = orderMapper.insertOutboundWaiting(waiting);
		if (w <= 0) throw new IllegalStateException("OUTBOUND_WAITING insert failed");

		return 1;
	}

	private String classifyByUrgent(String urgent) {
		return "Y".equalsIgnoreCase(urgent) ? "긴급" : "일반";
	}
	
	private String nextObwaitNumberWithAdvisoryLock() {
		String dateStr = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE); // YYYYMMDD
		String lockName = "OBWAIT_" + dateStr;

		Integer locked = orderMapper.getLock(lockName, 5);
		if (locked == null || locked != 1) {
			throw new IllegalStateException("Failed to acquire lock for obwait number");
		}

		try {
			Integer maxSuffix = orderMapper.selectMaxSuffixForDate(dateStr);
			int next = (maxSuffix == null ? 0 : maxSuffix) + 1;
			String suffix = String.format("%03d", next);
			return "OB" + dateStr + "-" + suffix;
		} finally {
			orderMapper.releaseLock(lockName);
		}
	}
}
