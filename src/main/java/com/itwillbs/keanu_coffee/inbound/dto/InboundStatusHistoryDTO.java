package com.itwillbs.keanu_coffee.inbound.dto;

import java.time.LocalDateTime;
import lombok.Data;

@Data
public class InboundStatusHistoryDTO {
    private String status;
    private LocalDateTime changedAt;
}
