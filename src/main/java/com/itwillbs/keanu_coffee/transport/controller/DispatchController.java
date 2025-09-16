package com.itwillbs.keanu_coffee.transport.controller;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.transport.dto.DeliveryConfirmationDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchAssignmentDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchCompleteRequest;
import com.itwillbs.keanu_coffee.transport.dto.DispatchDetailDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegisterRequestDTO;
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
	@ResponseBody
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
	@ResponseBody
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
	
	// 배차 상세 정보
	@GetMapping("/dispatch/detail/{dispatchIdx}/{vehicleIdx}")
	public ResponseEntity<?> getDispatchInfo(@PathVariable Integer dispatchIdx, @PathVariable Integer vehicleIdx) {
		String status = dispatchService.getDispatchStatus(dispatchIdx);
		
		if (status.equals("예약") || status.equals("취소")) {
			DispatchRegionGroupViewDTO dispatchInfo = dispatchService.selectDispatchInfo(dispatchIdx, vehicleIdx);
			return ResponseEntity.ok(dispatchInfo);
		} else {
			DispatchDetailDTO detail = dispatchService.selectDispatchDetail(dispatchIdx, vehicleIdx);
			return ResponseEntity.ok(detail);
		}
	}
	
	// 기사 마이페이지 배차 상세 정보
	@GetMapping("/mypage/dispatch/detail/{dispatchIdx}/{vehicleIdx}")
	public ResponseEntity<DispatchDetailDTO> getMyDispatchInfo(@PathVariable Integer dispatchIdx, @PathVariable Integer vehicleIdx) {
		// 배정된 기사의 상태
		String dispatchStatus = dispatchService.selectDispatchAssignment(dispatchIdx, vehicleIdx);
		
		if (dispatchStatus.equals("예약") || dispatchStatus.equals("취소")) {
			DispatchDetailDTO dispatchInfo = dispatchService.selectMyDispatchInfo(dispatchIdx, vehicleIdx);
			return ResponseEntity.ok(dispatchInfo);
		} else {
			DispatchDetailDTO detail = dispatchService.selectDispatchDetail(dispatchIdx, vehicleIdx);
			return ResponseEntity.ok(detail);
		}
	}
	
	// 기사 마이페이지 적재 완료
	@PostMapping("/mypage/dispatch/completed")
	@ResponseBody
	public ResponseEntity<String> addLoad(@RequestBody DispatchCompleteRequest request) {
		try {
			dispatchService.insertDispatchLoad(request);
			return ResponseEntity.ok("적재 완료");
		} catch (IllegalStateException e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST)
					 .contentType(new MediaType("text", "plain", StandardCharsets.UTF_8))
                    .body(e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("적재 등록 중 오류가 발생했습니다.");
		}
	}
	
	// 배송 시작
	@PostMapping("/mypage/delivery/start")
	@ResponseBody
	public ResponseEntity<String> modifyDeliveryStatusStart(@RequestBody DispatchRegisterRequestDTO request) {
		try {
			dispatchService.updateDispatchStatusStart(request);
			return ResponseEntity.ok("배송시작");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("배송 시작을 할 수 없습니다. 다시 시도해주세요.");
		}
	}
	
	// 납품 완료
	@PostMapping("/mypage/delivery/completed")
	@ResponseBody
	public ResponseEntity<String> modifyDeliveryCompleted(
			@RequestPart("request") DeliveryConfirmationDTO request, 
			@RequestPart(value = "files", required = false) List<MultipartFile> files, 
			Authentication authentication) {
		EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
		Integer empIdx = empDetail.getEmpIdx();
		
		try {
			// DTO에 파일 넣기
			if (files != null && !files.isEmpty()) {
	            request.setFiles(files.toArray(new MultipartFile[0]));
	        }
			
			dispatchService.updateDeliveryCompleted(request, empIdx);
			return ResponseEntity.ok("납품완료");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("납품 완료를 할 수 없습니다. 다시 시도해주세요.");
		}
	}
	
	// 기사 복귀
	@PostMapping("/mypage/delivery/return")
	@ResponseBody
	public ResponseEntity<String> modifyDeliveryReturn(@RequestBody DispatchAssignmentDTO request) {
		try {
			dispatchService.updateDeliveryReturn(request);
			return ResponseEntity.ok("복귀완료");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("다시 시도해주세요.");
		}
	}
	
	// 수주확인서 새창
	@GetMapping("/deliveryConfirmation/{deliveryConfirmationIdx}")
	public String getDeliveryConfirmationDetail(@PathVariable Integer deliveryConfirmationIdx, Model model) {
		// 수주확인서 상세 조회
		DeliveryConfirmationDTO confirmationDTO = dispatchService.selectDeliveryConfirmationByDeliveryConfirmationIdx(deliveryConfirmationIdx);
		// 기사 이름 조회
		String driverName = dispatchService.selectDriverName(deliveryConfirmationIdx);
		
		if (confirmationDTO == null || driverName == null) {
			model.addAttribute("msg", "수주확인서 정보를 불러올 수 없습니다.");
			model.addAttribute("targetURL", "/transport/deliveryConfirmation");
			return "commons/result_process";
		}
		
		model.addAttribute("confirmationDTO", confirmationDTO);
		model.addAttribute("driverName", driverName);
		
		return "/transport/deliveryConfirmationDetail";
	}
}
