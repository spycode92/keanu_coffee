package com.itwillbs.keanu_coffee.transport.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.transport.dto.VehicleDTO;
import com.itwillbs.keanu_coffee.transport.service.VehicleService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("transport")
@RequiredArgsConstructor
public class VehicleController {
	private final VehicleService vehicleService;
	
	private static final Pattern PLATE_PATTERN =
            Pattern.compile("^(?:[가-힣]{2,3})?(\\d{2,3})([가-힣])(\\d{4})$");
	
	// 차량 등록
	@PostMapping("/addVehicle")
	public String addVehicleForm(@ModelAttribute VehicleDTO vehicleDTO ,Model model) {
		String normalized  = normalizePlate(vehicleDTO.getVehicleNumber());
		if (normalized == null) {
			model.addAttribute("msg", "차량번호 형식이 올바르지 않습니다.");
			model.addAttribute("targetURL", "/transport/vehicle");
			return "commons/fail";
		}
		
		vehicleDTO.setVehicleNumber(normalized);
		
		if (vehicleDTO.getCapacity() == 1000) {
			vehicleDTO.setVolume(3000);
		} else {
			vehicleDTO.setVolume(4500);
		}
		
		boolean success = vehicleService.addVehicle(vehicleDTO);
		
		if (success) {
			model.addAttribute("msg", "차량을 등록했습니다.");
			model.addAttribute("targetURL", "/transport/vehicle");
		} else {
			model.addAttribute("msg", "차량 등록에 실패했습니다. 다시 시도해주세요.");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 차량 상세정보
	@GetMapping("/vehicle/detail")
	@ResponseBody
	public ResponseEntity<VehicleDTO> modifyVehicle(@RequestParam int idx) {
		VehicleDTO vehicleDTO = vehicleService.findByIdx(idx);
		
		// 데이터가 없을 경우 404 반환
		if (vehicleDTO == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(vehicleDTO);
	}
	
	// 차량 정보 수정
	@PostMapping("/vehicle/update")
	public String editVehicle(@ModelAttribute VehicleDTO vehicleDTO ,Model model) {
		String normalized  = normalizePlate(vehicleDTO.getVehicleNumber());
		if (normalized == null) {
			model.addAttribute("msg", "차량번호 형식이 올바르지 않습니다.");
			model.addAttribute("targetURL", "/transport/vehicle");
			return "commons/fail";
		}
		
		vehicleDTO.setVehicleNumber(normalized);
		
		boolean success = vehicleService.modifyVehicle(vehicleDTO);
		
		if (success) {
			model.addAttribute("msg", "차량 정보를 수정했습니다.");
			model.addAttribute("targetURL", "/transport/vehicle");
		} else {
			model.addAttribute("msg", "정보 수정에 실패했습니다. 다시 시도해주세요.");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 차량 상태 사용불가로 변경
	@PostMapping("/vehicle/status")
	@ResponseBody
	public ResponseEntity<?> deleteVehicles(@RequestBody Map<String, Object> body) {
		
		@SuppressWarnings("unchecked")
		List<Integer> idx = (List<Integer>) body.get("idx");
		
		String status = (String) body.get("status");
		
		if (idx == null || idx.isEmpty() || status == null) {
			return ResponseEntity.badRequest().build();
		}
		
		int deleted = vehicleService.modifyStatus(idx, status);
		
		return ResponseEntity.ok(Map.of("deleted", deleted));
	}
	
	// 배정 가능한 차량 리스트
	@GetMapping("/vehicle/available")
	@ResponseBody
	public ResponseEntity<List<VehicleDTO>> availableVehicleList(@RequestParam String status) {
		List<VehicleDTO> vehicles = vehicleService.getAvailableList(status);
		
		if (vehicles == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(vehicles);
	}
	
	// 기사 배정
	@PostMapping("/vehicle/edit")
	public ResponseEntity<VehicleDTO> modifyVehicleDriver(@RequestBody Map<String, String> body) {
		String vehicleIdxStr = (String) body.get("vehicleIdx");
		String empIdxStr = (String) body.get("empIdx");
		String isAssign =  (String) body.get("isAssign");
		
		Integer vehicleIdx = vehicleIdxStr != null ? Integer.parseInt(vehicleIdxStr) : null;
		Integer empIdx = empIdxStr != null ? Integer.parseInt(empIdxStr) : null;
		
		if (vehicleIdx == null || empIdx == null) {
			return ResponseEntity.badRequest().build();
		}
		
		int updateCount = vehicleService.modifyDrvier(vehicleIdx, empIdx, isAssign);
		
		if (updateCount < 0) {
			return ResponseEntity.notFound().build();
		}
		
		VehicleDTO vehicle = vehicleService.findByIdx(vehicleIdx);
		
		return ResponseEntity.ok(vehicle);
	}
	
	// 차량번호 중복 체크
	@GetMapping("/vehicle/dupCheck")
	@ResponseBody
	public Map<String, Boolean> checkDuplicate(@RequestParam String vehicleNumber, @RequestParam(required = false) Integer vehicleIdx) {
		String normalized  = normalizePlate(vehicleNumber);
		
		boolean isduplicate = false;
		
		if (normalized != null) {
			// 수정 시 차량 번호가 존재하고, 차량 번호는 수정하지 않을 경우 중복 검사
			if (vehicleIdx != null) {
				isduplicate = vehicleService.isVehicleNumberDuplicateExceptSelf(normalized, vehicleIdx);
			} else {
				// 차량 번호가 없을 경우 중복 검사
				isduplicate = vehicleService.isVehicleNumberDuplicate(normalized);
			}
		}
		
		Map<String, Boolean> result = new HashMap<String, Boolean>();
		
		result.put("duplicate", isduplicate);
		return result;
	}
	
	// 차량번호 정규화
	private static String normalizePlate(String vehicleNumber) {
		if (vehicleNumber == null) {
			return null;
		}
		
		// 공백과 하이픈 제거
		String compact = vehicleNumber.replaceAll("[\\s-]", "");
		Matcher match = PLATE_PATTERN.matcher(compact);
		
		if (!match.matches()) {
			return null;
		}
		
		return match.group(1) + match.group(2) + match.group(3);
	}

	

}