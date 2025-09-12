package com.itwillbs.keanu_coffee.outbound.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OutboundOrderDTO {

    // PK
    private Integer outboundOrderIdx;     // 출고주문 idx

    // 기본정보
    private Integer franchiseIdx;         // 가맹점 idx

    // 허용값 예시: "대기","출고준비","배차대기","배차완료","적재완료","출고완료","운송완료","취소" 
    private String status;                // 출고상태

    // 긴급 여부: 'Y' or 'N'
    private String urgent;               

    private LocalDateTime requestedDate;       // 요청일시
    private LocalDateTime expectOutboundDate;  // 출고예정일시

    private LocalDateTime createdAt;      // 생성시각
    private LocalDateTime updatedAt;      // 수정시각

    // 포함 관계
    private List<OutboundOrderItemDTO> items; 
}
