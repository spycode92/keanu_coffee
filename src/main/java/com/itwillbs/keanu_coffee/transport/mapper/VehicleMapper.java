
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

	// 차량 상세정보
	VehicleDTO selectByIdx(int idx);

	// 차량 사용불가 상태로 변경
	int updateStatus(@Param("idx") List<Integer> idx, @Param("status") String status);

	// 배정 가능한 차량 목록
	List<VehicleDTO> selectAvailableList(String status);

	// 기사 배정
	int updateDriver(@Param("vehicleIdx") Integer vehicleIdx, @Param("empIdx") Integer empIdx, @Param("isAssign") String isAssign);

	// 차량 정보 수정
	int updateVehicle(VehicleDTO vehicleDTO);

	// 차량번호 중복검사(수정 시)
	int countByVehicleNumberExceptSelf(@Param("vehicleNumber") String vehicleNumber, @Param("vehicleIdx") Integer vehicleIdx);
	
	// 차량번호 중복검사(등록 시)
	int countByVehicleNumber(String vehicleNumber);
}
