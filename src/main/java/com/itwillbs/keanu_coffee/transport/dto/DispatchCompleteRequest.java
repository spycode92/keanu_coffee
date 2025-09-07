package com.itwillbs.keanu_coffee.transport.dto;

import java.util.List;

import lombok.Data;

@Data
public class DispatchCompleteRequest {
    private Integer dispatchIdx;          // 배차 고유번호 
    private Integer vehicleIdx;           // 차량 고유번호
    private char urgent;
    private List<StopComplete> stops;     // 선택한 경유지별 납품 데이터
    
    @Data
    public static class StopComplete {
        private Integer routeIdx;         // 경로 고유번호 
        private Integer franchiseIdx;     // 지점 고유번호
        private Integer outboundOrderIdx; // 출고 고유번호
        private Integer deliverySequence; // 배송순서
        private List<ItemComplete> items; // 각 지점의 납품 품목
    }
    
    @Data
    public static class ItemComplete {
        private Integer productIdx;       // 품목 고유번호
        private String itemName;          // 품목 이름
        private Integer orderedQty;       // 주문 수량
        private Integer deliveredQty;     // 실제 납품 수량
        private String Status;            // 납품 상태
        private String note;              // 비고
    }
    
    // 내부ㅠ enum 선언
    public enum Status {
    	 OK,
         REFUND,
         PARTIAL_REFUND
    }
}
