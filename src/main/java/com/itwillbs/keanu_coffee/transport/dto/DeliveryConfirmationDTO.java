package com.itwillbs.keanu_coffee.transport.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class DeliveryConfirmationDTO {
	   private Integer deliveryConfirmationIdx;  // 고유번호
	   private Integer dispatchAssignmentIdx;    // 배차 배정 고유번호
	   private Integer dispatchStopIdx;          // 경유지 고유번호
	   private Integer outboundOrderIdx;         // 출고주문 고유번호
	   private Timestamp confirmationTime;       // 수주확인 시간
	   private String receiverName;              // 수령자
	   private String note;                      // 비고
	   
	   private List<DeliveryConfirmationItemDTO> items;
}
