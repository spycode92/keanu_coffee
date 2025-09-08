package com.itwillbs.keanu_coffee.outbound.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.outbound.dto.OutboundWaitingDTO;

@Mapper
public interface OutboundMapper {
	
	// ================================================== 출고지시 =====================
	// OUTBOUND_ORDER
	int insertOutboundOrder(OutboundOrderDTO order);
	
	// OUTBOUND_ORDER_ITEM
	int insertOutboundOrderItem(OutboundOrderItemDTO item);
	
	// OUTBOUND_WAITING
	int insertOutboundWaiting(OutboundWaitingDTO waiting);
	
	// OUTBOUND_seq생성
	Integer getLock(@Param("lockName") String lockName, @Param("timeout") int timeout);
	Integer selectMaxSuffixForDate(@Param("dateStr") String dateStr);
	Integer releaseLock(@Param("lockName") String lockName);
	
	// =================================================================================
}
