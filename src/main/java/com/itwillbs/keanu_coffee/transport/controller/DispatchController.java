package com.itwillbs.keanu_coffee.transport.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegisterRequestDTO;
import com.itwillbs.keanu_coffee.transport.dto.DriverVehicleDTO;
import com.itwillbs.keanu_coffee.transport.service.DispatchService;
import com.itwillbs.keanu_coffee.transport.service.DriverService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("transport")
@RequiredArgsConstructor
public class DispatchController {
	private final DispatchService dispatchService;
	private final DriverService driverService;
	
	// 배차 요청 리스트
	@GetMapping("/dispatch/list")
	public ResponseEntity<List<DispatchRegionGroupViewDTO>> getAllDispatch() {
		List<DispatchRegionGroupViewDTO> dispatchList = dispatchService.getDispatchList();
		
		if (dispatchList == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(dispatchList);
	}
	
	
	// 가용 가능한 기사 목록
	@GetMapping("/dispatch/availableDrivers")
	public ResponseEntity<List<DriverVehicleDTO>> getAllAvailableDrivers() {
		List<DriverVehicleDTO> availableDriverList = driverService.getAvailableDrivers();
		
		if (availableDriverList == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(availableDriverList);
	}
	
	// 배차 등록
	@PostMapping("/dispatch/add")
	public ResponseEntity<String> addDispatch(@RequestBody DispatchRegisterRequestDTO request) {		
		try {
			dispatchService.insertDispatch(request);
			return ResponseEntity.ok("배차 등록 완료");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("배차 등록 중 오류가 발생했습니다.");
		}
	}
	
	// 배차 취소
	@PostMapping("/dispatch/cancel")
	public ResponseEntity<String> modifyDispatchStatus(@RequestBody DispatchRegisterRequestDTO request) {
		try {
			dispatchService.updateDispatchStatus(request);
			return ResponseEntity.ok("배차 취소 완료");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("배차 취소 중 오류가 발생했습니다.");
		}
	}
}
