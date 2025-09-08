package com.itwillbs.keanu_coffee.outbound.dto;

import lombok.Data;
import java.util.List;

@Data
public class OutboundDTO {
    private OutboundOrderDTO order;
    private List<OutboundOrderItemDTO> items;
    private List<OutboundWaitingDTO> waitingList;
}

