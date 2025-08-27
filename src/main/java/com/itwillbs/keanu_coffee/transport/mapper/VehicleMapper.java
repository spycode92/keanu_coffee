package com.itwillbs.keanu_coffee.transport.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.transport.dto.VehicleDTO;

public interface VehicleMapper {

	// 차량관리 페이징
	int selectVehicleCount(@Param("filter") String filter, @Param("searchKeyword") String searchKeyword);
	
	// 차량 리스트
	List<VehicleDTO> selectVehicleList(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("filter") String filter, @Param("searchKeyword") String searchKeyword);
	
	// 차량 추가
	int insertVehicle(VehicleDTO vehicleDTO);

	// 차량번호 중복검사
	int countByVehicleNumber(String vehicleNumber);

	// 차량 상세정보
	VehicleDTO selectByIdx(int idx);

	// 차량 사용불가 상태로 변경
	int updateStatus(@Param("idx") List<Integer> idx, @Param("status") String status);


}
