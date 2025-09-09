package com.itwillbs.keanu_coffee.transport.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class DispatchAssignmentDTO {
	private Integer dispatchAssignmentIdx;
	private Integer dispatchIdx;
	private Integer vehicleIdx;
	private Integer empIdx;
	private String status; // 예약, 적재완료, 운행중, 완료, 취소
}
