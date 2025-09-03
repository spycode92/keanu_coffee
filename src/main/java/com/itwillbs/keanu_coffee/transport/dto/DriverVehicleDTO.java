package com.itwillbs.keanu_coffee.transport.dto;

import lombok.Getter;

@Getter
public class DriverVehicleDTO {
	private Integer empIdx;
	private String empNo;          // 사번 (PK)
	private String empName;        // 이름
	private String empPhone;          // 전화번호
	private String empStatus;         // 재직 상태 ('재직','퇴사','휴직')
	private Integer vehicleIdx;
	private String vehicleNumber;
	private String vehicleType; // 차량 종류
	private int capacity; // 적재용량
	private int volume; // 적재부피
	private VehicleStatus status;
}
