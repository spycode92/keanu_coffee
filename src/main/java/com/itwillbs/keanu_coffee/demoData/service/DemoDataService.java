package com.itwillbs.keanu_coffee.demoData.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplyContractDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseOrderItemDTO;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.demoData.dto.DemoDataDTO;
import com.itwillbs.keanu_coffee.demoData.mapper.DemoDataMapper;
import com.itwillbs.keanu_coffee.inbound.dto.InboundDetailDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DemoDataService {

	private final DemoDataMapper demoDataMapper;
	
	public void main() {
		List<SupplyContractDTO> contractList = demoDataMapper.selectContractList();
	}
	
	public void makePO(DemoDataDTO demoData) {
		//발주 주문 삽입
		LocalDate startDate = demoData.getStartDate();
	    LocalDate endDate = demoData.getEndDate();
	    //공급계약리스트
	    List<SupplyContractDTO> contractList = demoDataMapper.selectContractList();
//	    System.out.println(contractList);
		
	    for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
	    	int purchaseOrderItemSum = 0;
	    	int dailySequence = getNextDailySequence(date);
	    	String seqStringPO = String.format("%02d", dailySequence);
	        PurchaseOrderDTO purchaseOrder = new PurchaseOrderDTO();
	        purchaseOrder.setOrderIdx(date.format(DateTimeFormatter.BASIC_ISO_DATE) + seqStringPO);
	        purchaseOrder.setOrderDate(date.atStartOfDay());
	        purchaseOrder.setOrderNumber("PO-" + date.format(DateTimeFormatter.BASIC_ISO_DATE) + "-" + dailySequence );
	        
	        purchaseOrder.setStatus("요청중");
	        purchaseOrder.setExpectedArrivalDate(date.plusDays(3));
//	        purchaseOrder.setInboundClassification("일반"); // 기본값

	        // 발주주문 저장
	        demoDataMapper.insertPurchaseOrder(purchaseOrder);
	        // 주문번호 저장
	        String orderIdx = purchaseOrder.getOrderIdx();
	        
	        //공급계약 랜덤지정
	        List<SupplyContractDTO> randomContracts = pickRandomContracts(contractList, 3);
	        //발주아이템 주문 저장
	        for (SupplyContractDTO contract : randomContracts) {
	            PurchaseOrderItemDTO item = new PurchaseOrderItemDTO();
	            int maxSeqPOI = demoDataMapper.findMaxLotSequence(orderIdx, date);
	            int nextSeqPOI = (maxSeqPOI == 0) ? 1 : maxSeqPOI + 1;
	            String seqStringPOI = String.format("%03d", nextSeqPOI);

	            item.setOrderIdx(orderIdx);
	            item.setProductIdx(contract.getProductIdx());
	            item.setQuantity(contract.getMinOrderQuantity()); // 예시로 minOrderQuantity 사용
	            item.setUnitPrice(new BigDecimal(contract.getContractPrice())); // 계약 단가  
	            BigDecimal quantityBD = new BigDecimal(item.getQuantity());
	            item.setTotalPrice(item.getUnitPrice().multiply(quantityBD));

	            // lot_number 생성 (예: orderIdx, productIdx, timestamp 조합)
	            String lotNumber = "LOT-" + date.format(DateTimeFormatter.BASIC_ISO_DATE) + "-" + seqStringPOI;
	            
	            item.setLotNumber(lotNumber);

	            demoDataMapper.insertPurchaseOrderItem(item);
	            purchaseOrderItemSum += item.getQuantity();
	        }
	        //입고대기 정보저장
            InboundDetailDTO IBWait = new InboundDetailDTO();
            int maxSeqIBW = demoDataMapper.findMaxIbwaitSequence(date);
            int nextSeqIBW = (maxSeqIBW == 0) ? 1 : maxSeqIBW + 1;
            String seqStringIBW = String.format("%03d", nextSeqIBW);
            String ibwaitNumber = "IB" + date.format(DateTimeFormatter.BASIC_ISO_DATE) + "-" + seqStringIBW;  // 예: IB20250925-01
            IBWait.setIbwaitNumber(ibwaitNumber);  // 입고대기 고유번호
            IBWait.setOrderIdx(orderIdx);          // 발주주문 번호
            IBWait.setExpectedArrivalDate(date.plusDays(3).atStartOfDay());   // 예상 입고일(LocalDate)
            IBWait.setArrivalDate(date.plusDays(3).atStartOfDay()); // 입고일(LocalDateTime)
            IBWait.setQuantity(purchaseOrderItemSum);    // 수량
            IBWait.setNumberOfItems(3);                 // 품목 개수 (필요에 따라 조정)
            IBWait.setInboundClassification("일반");    // 입고 구분
            IBWait.setInboundStatus("대기");             // 입고 상태
            IBWait.setManager(null);                     // 매니저 (null 가능)
            IBWait.setInboundLocation(null);             // 입고 위치 (null 가능)
            IBWait.setNote(null);                        // 비고 (필요 시 작성)
            
            demoDataMapper.insertInboundWaiting(IBWait);
	    }
	}
	
	//발주주문 순서번호 구하기
	private int getNextDailySequence(LocalDate date) {
	    // DB 쿼리로 date 당 가장 큰 sequence 번호 조회 후 +1 반환
	    Integer maxSeq = demoDataMapper.findMaxSequenceByDate(date);
	    return (maxSeq == null) ? 1 : maxSeq + 1;
	}
	
	// 계약 리스트에서 랜덤으로 중복없이 n개 선택
	private List<SupplyContractDTO> pickRandomContracts(List<SupplyContractDTO> contractList, int n) {
	    if (contractList.size() <= n) {
	        return new ArrayList<>(contractList);
	    }
	    List<SupplyContractDTO> copyList = new ArrayList<>(contractList);
	    Collections.shuffle(copyList);
	    return copyList.subList(0, n);
	}
}
