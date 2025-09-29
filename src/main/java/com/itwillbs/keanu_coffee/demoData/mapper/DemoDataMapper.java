package com.itwillbs.keanu_coffee.demoData.mapper;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplyContractDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;

@Mapper
public interface DemoDataMapper {
	
	
	//발주주문 생성
	void insertPurchaseOrder(PurchaseOrderDTO purchaseOrder);
	//발주주문 번호체크
	Integer findMaxSequenceByDate(LocalDate date);
	//공급계약정보가져오기
	List<SupplyContractDTO> selectContractList();
	//발주아이템 로트번호생성준비
	int findMaxLotSequence(@Param("orderIdx") String orderIdx, @Param("date")LocalDate date);
	//발주상품 생성	
	void insertPurchaseOrderItem(PurchaseOrderItemDTO item);
	//입고대기 번호 시퀀스구하기
	int findMaxIbwaitSequence(LocalDate date);
	//입고대기 목록 생성
	void insertInboundWaiting(InboundDetailDTO iBWait);

	
	
}
