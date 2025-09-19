package com.itwillbs.keanu_coffee.common.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.common.aop.annotation.WorkingLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.WorkingLogTarget;
import com.itwillbs.keanu_coffee.common.dto.AlarmDTO;
import com.itwillbs.keanu_coffee.common.dto.PurchaseWithSupplierDTO;
import com.itwillbs.keanu_coffee.common.mapper.PurchaseOrderMapper;
import com.itwillbs.keanu_coffee.inventory.dto.OutboundOrderItemDTO;
import com.itwillbs.keanu_coffee.inventory.dto.SupplierProductContractDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {

	private final PurchaseOrderMapper purchaseOrderMapper;
	private final SimpMessagingTemplate messagingTemplate;
	private final AlarmService alarmService;
	
//	public List<PurchaseWithSupplierDTO> orderDetail() {
//		return purchaseOrderMapper.orderDetail();
//	}

	public String getTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber() {
		
		return purchaseOrderMapper.selectTodaysPurchaseOrderNumbersInOrderToMakeNewPurchaseOrderNumber();
	}
	
	@Transactional
	@WorkingLog(target = WorkingLogTarget.PURCHACE_ORDER)
	public void addProductOrder(int orderIdx, String orderNumber, int supplierIdx, LocalDateTime orderDate, LocalDate expectedArrivalDate) {
		
		purchaseOrderMapper.insertProductOrder(orderIdx, orderNumber, supplierIdx, orderDate, expectedArrivalDate);	
	}
	
	@Transactional
	public void addInboundWaitingOrder(String inboundWaitingNumber, int orderIdx, int quantity, int numberOfItems,
			LocalDate expectedArrivalDate) {
		//Alarm
		AlarmDTO alarm = new AlarmDTO();
		//receiver
		alarm.setRoleName("입고관리자");
		//Url
//		alarm.setEmpAlarmLink("/main");
		//message
		alarm.setEmpAlarmMessage(inboundWaitingNumber + "번 입고대기 목록이 생성되었습니다.");
		
		alarmService.insertAlarmByRole(alarm);
		
		Map<String, String> payload = new HashMap<>();
		payload.put("message", "새알림이 도착하였습니다.");
		messagingTemplate.convertAndSend("/topic/" + alarm.getRoleName(), payload);
		
		purchaseOrderMapper.insertInboundWaiting(inboundWaitingNumber, orderIdx, quantity, numberOfItems, expectedArrivalDate);
	}
	
	@Transactional
	public void addProductOrderItem(int orderIdx, int productIdx, double quantity, int contractPrice) {

		purchaseOrderMapper.insertProductOrderItem(orderIdx, productIdx, quantity, contractPrice);
	}

	public List<OutboundOrderItemDTO> getLastMonthsDemand(int month, int year, int daysInLastMonth) {
		// TODO Auto-generated method stub
		return purchaseOrderMapper.selectLastMonthsDemand(month, year, daysInLastMonth);
	}

	public List<OutboundOrderItemDTO> getLastMonthsDemandYearAgo(int i, int j, int daysInLastMonth2) {
		// TODO Auto-generated method stub
		return purchaseOrderMapper.selectLastMonthsDemand(i, j, daysInLastMonth2);
	}

	public List<OutboundOrderItemDTO> getAvgDemandSameWeekOneYearAgo(LocalDate startDate, LocalDate endDate, double beta) {
		// TODO Auto-generated method stub
		return purchaseOrderMapper.seletAvgDemandSameWeekOneYearAgo(startDate, endDate, beta);
	}
	public List<OutboundOrderItemDTO> getLastMonthsDemandItemsEveryDay(int month, int year) {
		// TODO Auto-generated method stub
		return purchaseOrderMapper.selectLastMonthsDemandItemsEveryDay(month, year);
	}
	
	public double getPercentOfWarehouseUsed() {
		return purchaseOrderMapper.selectPercentOfWarehouseUsed();
	}

	public List<OutboundOrderItemDTO> getInventoryQuantity() {
		return purchaseOrderMapper.selectInventoryQuantity();
	}

	public List<OutboundOrderItemDTO> getInboundWaitingQuantity() {
		// TODO Auto-generated method stub
		return purchaseOrderMapper.selectInboundWaitingQuantity();
	}

	public List<SupplierProductContractDTO> getcontracts() {
		return purchaseOrderMapper.selectContracts();
	}

	public List<SupplierProductContractDTO> getProductAndSuppplier() {
		return purchaseOrderMapper.selectProductAndSuppplier();
	}
	



	

	
}
