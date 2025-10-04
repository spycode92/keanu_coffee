package com.itwillbs.keanu_coffee.transport.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.transport.dto.DriverVehicleDTO;
import com.itwillbs.keanu_coffee.transport.service.DriverService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("transport")
@RequiredArgsConstructor
public class DriverController {
	private final DriverService driverService;
	
	// 차량 배정 가능한 운전기사 요청 API
	@GetMapping("/assignDriver")
	@ResponseBody
	public ResponseEntity<List<EmployeeInfoDTO>> getAllAssignDriver() {
		List<EmployeeInfoDTO> driverDTO = driverService.getDriverList();
		
		return ResponseEntity.ok(driverDTO == null ? List.of() : driverDTO);
	}
	
	// 기사 상세 정보
	@GetMapping("/drivers/detail")
	@ResponseBody
	public ResponseEntity<DriverVehicleDTO> getDriver(@RequestParam Integer idx) {
		DriverVehicleDTO driver = driverService.getDriver(idx);
		
		if (driver == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(driver);
	}
}
