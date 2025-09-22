package com.itwillbs.keanu_coffee.outbound.dto;

import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class OutboundManagementDTO {
	private int obwaitIdx;
    private String obwaitNumber;       // 출고번호 (o.obwait_number)
    private Long outboundOrderIdx;     // 출고오더 IDX
    private LocalDate departureDate;   // 출고일자
    private String outboundLocation;   // 출고위치
    private String franchiseName;      // 프랜차이즈 업체명
    private String status;             // 상태
    private int itemCount;             // 품목수
    private int totalQuantity;         // 출고예정수량
    private String manager;            // 담당자
    private String note;               // 비고
    private LocalDateTime createdAt;   // 생성일 (정렬용)
}