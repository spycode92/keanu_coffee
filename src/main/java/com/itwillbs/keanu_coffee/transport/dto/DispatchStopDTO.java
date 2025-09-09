package com.itwillbs.keanu_coffee.transport.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

@Data
public class DispatchStopDTO {
    private Integer dispatchStopIdx;        // 고유번호
    private Integer dispatchIdx;            // 배차 고유번호
    private Integer dispatchAssignmentIdx;  // 배차 배정 고유번호
    private Integer regionIdx;
    private Integer deliverySequence;       // 배송 순서
    private Integer franchiseIdx;           // 지점 고유번호
    private String franchiseName;           // 지점명
    private String franchiseManagerName;
    private String Status;                  // 납품 상태 (대기, 운송중, 납품완료)
    private Timestamp arrivalTime;          // 도착 시간
    private Timestamp completeTime;         // 납품 완료 시간
    private char urgent;                     // 긴급 여부
    private String note;                    // 비고
    
    private List<DeliveryConfirmationDTO> deliveryConfirmations;
    
    public enum Status {
    	대기, 운송중, 납품완료
    }
}
