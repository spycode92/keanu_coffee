package com.itwillbs.keanu_coffee.outbound.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class OutboundInspectionDTO {

    // 출고 대기 기본정보
    private Long obwaitIdx;           // 출고대기 PK
    private String obwaitNumber;      // 출고번호
    private LocalDateTime departureDate; // 출고일자
    
    private Integer outboundOrderIdx;    // 출고오더 PK
    private String franchiseName;     // 프랜차이즈명
    
    private String manager;           // 담당자명
    private String outboundLocation;  // 출고위치
    private String note;              // 비고
    
    // 집계 데이터
    private Integer itemCount;        // 총 품목 수
    private Integer totalQuantity;    // 총 수량
    
    // 기타
    private String outboundClassification; // 출고 구분
    private String status;                 // 출고 상태
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
