package com.itwillbs.keanu_coffee.transport.dto;

import lombok.Data;

@Data
public class RouteDTO {
	private Integer routeIdx;
	private Integer regionIdx;
	private Integer deliverySequence;
	private Integer franchiseIdx;
	private String note;
;
}
