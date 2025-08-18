package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.transport.dto.VehicleDTO;
import com.itwillbs.keanu_coffee.transport.mapper.VehicleMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VehicleService {
	private final VehicleMapper vehicleMapper;

	// 차량관리 페이징
	public int getVehicleCount(String filter, String searchKeyword) {
		return vehicleMapper.selectVehicleCount(filter, searchKeyword);
	}
	
	// 차량 리스트
	public List<VehicleDTO> getVehicleList(int startRow, int listLimit, String filter, String searchKeyword) {
		return vehicleMapper.selectVehicleList(startRow, listLimit, filter, searchKeyword);
	}
	
	// 차량 추가
	public boolean addVehicle(VehicleDTO vehicleDTO) {
		return vehicleMapper.insertVehicle(vehicleDTO) > 0;
	}

	// 차량번호 중복검사
	public boolean isVehicleNumberDuplicate(String vehicleNumber) {
		return vehicleMapper.countByVehicleNumber(vehicleNumber) > 0;
	}

	// 차량 상세정보
	public VehicleDTO findByIdx(int idx) {
		return vehicleMapper.selectByIdx(idx);
	}

	// 차량 삭제
	public int deleteByIdx(List<Integer> idx) {
		return vehicleMapper.deleteByIdx(idx);
	}


}
