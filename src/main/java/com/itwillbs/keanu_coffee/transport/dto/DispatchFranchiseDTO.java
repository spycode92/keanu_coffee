package com.itwillbs.keanu_coffee.transport.dto;

import java.util.List;

import com.itwillbs.keanu_coffee.outbound.dto.OutboundOrderItemDTO;

import lombok.Data;

@Data
public class DispatchFranchiseDTO {
	private Integer franchiseIdx;
    private String franchiseName;
    private Integer regionIdx; 
    private String regionName; 
    private String franchiseZipcode;
    private String franchiseAddress1;
    private String franchiseAddress2;
    private String franchisePhone;
    private String franchiseManagerName;
    private String status;

    private List<OutboundOrderItemDTO> items; // 지점별 품목 리스트
}
