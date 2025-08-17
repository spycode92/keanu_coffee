package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.transport.dto.VehicleDTO;

public interface VehicleMapper {

	// 차량관리 페이징
	int selectVehicleCount(String filter);
	
	// 차량 리스트
	List<VehicleDTO> selectVehicleList(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("filter")String filter);
	
	// 차량 추가
	int insertVehicle(VehicleDTO vehicleDTO);

	// 차량번호 중복검사
	int countByVehicleNumber(String vehicleNumber);


}
