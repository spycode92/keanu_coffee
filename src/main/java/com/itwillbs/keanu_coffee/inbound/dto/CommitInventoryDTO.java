package com.itwillbs.keanu_coffee.inbound.dto;

import java.util.List;

import lombok.Data;

@Data
public class CommitInventoryDTO {
    private Integer ibwaitIdx; 
    private List<InventoryItemDTO> items;

    @Data
    public static class InventoryItemDTO {
    	private Integer receiptProductIdx;
        private Integer productIdx;
        private String lotNumber;
        private Integer quantity;
        private String manufactureDate;
        private String expirationDate;
        private Integer locationIdx;   // 9999, 9998, 9997
        private String locationName;   // Location_F, G, H
        private Integer ibwaitIdx;
    }
}