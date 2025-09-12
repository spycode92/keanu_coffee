package com.itwillbs.keanu_coffee.outbound.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class OutboundManagementDTO {

    private Integer outboundOrderIdx;   // 출고 주문 IDX
    private String obwaitNumber;      // OUTBOUND_WAITING.obwait_number
    private Date departureDate;       // OUTBOUND_WAITING.departure_date
    private String outboundLocation;    // OUTBOUND_WAITING.outbound_location
    private String franchiseName;       // FRANCHISE.franchise_name
    private String status;              // OUTBOUND_ORDER.status
    private Integer itemCount;          // COUNT(oi.outbound_order_item_idx)
    private Integer totalQuantity;      // SUM(oi.quantity)
    private String manager;             // OUTBOUND_WAITING.manager
    private String note;                // OUTBOUND_WAITING.note
}

