package com.itwillbs.keanu_coffee.transport.dto;

import lombok.Data;

@Data
public class RegionFranchiseRouteDTO {
	private Integer franchiseIdx;
	private Integer routeIdx;
	private Integer regionIdx;
	private String franchiseName;
	private String commonCodeName;
	private Integer deliverySequence;
	
}
