package com.itwillbs.keanu_coffee.transport.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DriverVehicleDTO;
import com.itwillbs.keanu_coffee.transport.service.DispatchService;
import com.itwillbs.keanu_coffee.transport.service.DriverService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("transport")
@RequiredArgsConstructor
public class DispatchController {
	private final DispatchService dispatchService;
	private final DriverService driverService;
	
	// 배차 요청 리스트
	@GetMapping("/dispatch/lsit")
	@ResponseBody
	public ResponseEntity<List<DispatchRegionGroupViewDTO>> dispatchList() {
		List<DispatchRegionGroupViewDTO> dispatchList = dispatchService.getDispatchList();
		
		if (dispatchList == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(dispatchList);
	}
	
	
	// 가용 가능한 기사 목록
	@GetMapping("/dispatch/availableDrivers")
	@ResponseBody
	public ResponseEntity<List<DriverVehicleDTO>> availableDrivers() {
		List<DriverVehicleDTO> availableDriverList = driverService.getAvailableDrivers();
		
		if (availableDriverList == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(availableDriverList);
	}
}
