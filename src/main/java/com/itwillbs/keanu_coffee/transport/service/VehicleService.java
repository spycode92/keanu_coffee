package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.transport.dto.DispatchAssignmentDTO;
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
	@Transactional(readOnly = true)
	public List<VehicleDTO> getVehicleList(int startRow, int listLimit, String filter, String searchKeyword, String orderKey, String orderMethod) {
		return vehicleMapper.selectVehicleList(startRow, listLimit, filter, searchKeyword, orderKey, orderMethod);
	}
	
	// 차량 추가
	public boolean addVehicle(VehicleDTO vehicleDTO) {
		return vehicleMapper.insertVehicle(vehicleDTO) > 0;
	}

	// 차량 상세정보
	@Transactional(readOnly = true)
	public VehicleDTO findByIdx(int idx) {
		return vehicleMapper.selectByIdx(idx);
	}

	// 차량 상태 사용불가로 변경
	public int modifyStatus(List<Integer> idx, String status) {
		return vehicleMapper.updateStatus(idx, status);
	}

	// 배정 가능한 차량 목록
	@Transactional(readOnly = true)
	public List<VehicleDTO> getAvailableList(String status) {
		return vehicleMapper.selectAvailableList(status);
	}

	// 기사 배정
	public int modifyDrvier(Integer vehicleIdx, Integer empIdx, String isAssign) {
		return vehicleMapper.updateDriver(vehicleIdx, empIdx, isAssign);
	}

	// 차량 정보 수정
	public boolean modifyVehicle(VehicleDTO vehicleDTO) {
		return vehicleMapper.updateVehicle(vehicleDTO) > 0;
	}

	// 차량번호 중복검사 (수정 시)
	public boolean isVehicleNumberDuplicateExceptSelf(String vehicleNumber, Integer vehicleIdx) {
		return vehicleMapper.countByVehicleNumberExceptSelf(vehicleNumber, vehicleIdx) > 0;
	}
	
	// 차량번호 중복검사 (신규 등록 시)
	public boolean isVehicleNumberDuplicate(String vehicleNumber) {
		return vehicleMapper.countByVehicleNumber(vehicleNumber) > 0;
	}


}