package com.itwillbs.keanu_coffee.transport.dto;

import lombok.Data;

@Data
public class VehicleDTO {
	private Integer vehicleIdx;
	private String vehicleNumber; // 차량번호
	private String vehicleType; // 차량 종류
	private int capacity; // 적재용량
	private int volume; // 적재 부피
	private VehicleStatus status; // 차량 상태
	private int manufactureYear; // 연식
	private String manufacturerModel; //모델/제조사
	private int empIdx; //운전자 idx
	private String driverName; // 운전자 이름
}
