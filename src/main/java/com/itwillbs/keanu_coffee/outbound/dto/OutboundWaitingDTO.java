package com.itwillbs.keanu_coffee.outbound.dto;

import java.time.LocalDateTime;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OutboundWaitingDTO {

    // PK
    private Integer obwaitIdx;            // 대기 idx

    // 기본정보
    private String  obwaitNumber;         // 대기번호(OB + 날짜 + 3자리숫자)
    private Integer outboundOrderIdx;     // 출고주문 idx(FK)

    private LocalDateTime DepartureDate;    // 출고일
    private Integer outboundQuantity;     // 출고수량(대기단계에서 확정 수량)

    private String  outboundClassification; // 출고 구분(일반/긴급)
    private String  manager;                // 담당자
    private String  outboundLocation;       // 출고 위치
    private String  note;                   // 비고

    private LocalDateTime createdAt;      // 생성일시
    private LocalDateTime updatedAt;      // 수정일시
}
