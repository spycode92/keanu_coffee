package com.itwillbs.keanu_coffee.inventory.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OutboundOrderDTO {
    private int outboundOrderIdx;
    private int franchiseIdx;
    private String status;
    private LocalDateTime requestedDate;
    private LocalDateTime expectOutboundDate;
}

