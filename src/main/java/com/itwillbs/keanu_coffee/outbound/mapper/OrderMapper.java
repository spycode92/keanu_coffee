package com.itwillbs.keanu_coffee.outbound.mapper;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;

public interface OrderMapper {
	// OUTBOUND_ORDER
	int insertOutboundOrder(OutboundOrderDTO order);
	
	// (기존 단건 INSERT - 현재 FEFO 자동배분으로는 사용하지 않음, 필요시 유지)
	int insertOutboundOrderItem(OutboundOrderItemDTO item);

	// FEFO 자동 배분 INSERT (여러 행 삽입 가능)
	int insertOutboundItemsFefo(@Param("outboundOrderIdx") Integer outboundOrderIdx,
								@Param("productIdx") Integer productIdx,
								@Param("requiredQty") Integer requiredQty);
	
	// OUTBOUND_WAITING
	int insertOutboundWaiting(OutboundWaitingDTO waiting);
	
	// OUTBOUND_seq 생성
	Integer getLock(@Param("lockName") String lockName, @Param("timeout") int timeout);
	Integer selectMaxSuffixForDate(@Param("dateStr") String dateStr);
	Integer releaseLock(@Param("lockName") String lockName);
}
