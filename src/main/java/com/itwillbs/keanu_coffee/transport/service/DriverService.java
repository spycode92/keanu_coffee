package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.transport.dto.DriverVehicleDTO;
import com.itwillbs.keanu_coffee.transport.mapper.DriverMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DriverService {
	private final DriverMapper driverMapper;

	// 차량 배정 가능한 운전자 리스트
	public List<EmployeeInfoDTO> getDriverList() {
		return driverMapper.selectDriverList();
	}

	// 페이징을 위한 운전자 수
	public int getDriverCount(String filter, String searchKeyword) {
		return driverMapper.selectDriverCount(filter, searchKeyword);
	}

	// 페이징된 운전자 리스트
	public List<DriverVehicleDTO> getDriverList(int startRow, int listLimit, String filter, String searchKeyword) {
		return driverMapper.selectDriverList(startRow, listLimit, filter, searchKeyword);
	}

	// 운전자 상세정보
	public DriverVehicleDTO getDriver(Integer idx) {
		return driverMapper.selectDriver(idx);
	}

}
