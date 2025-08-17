package com.itwillbs.keanu_coffee.transport.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
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
	public String addVehicleForm(@ModelAttribute VehicleDTO vehicleDTO, RedirectAttributes rttr ,Model model) {
		String normalized  = normalizePlate(vehicleDTO.getVehicleNumber());
		if (normalized == null) {
			model.addAttribute("msg", "차량번호 형식이 올바르지 않습니다.");
			model.addAttribute("targetURL", "/transport/vehicle");
			return "commons/fail";
		}
		
		vehicleDTO.setVehicleNumber(normalized);
		
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
	
	// 차량번호 중복 체크
	@GetMapping("/vehicle/dupCheck")
	@ResponseBody
	public Map<String, Boolean> checkDuplicate(@RequestParam String vehicleNumber) {
		String normalized  = normalizePlate(vehicleNumber);
		boolean isduplicate = (normalized != null) && vehicleService.isVehicleNumberDuplicate(normalized);
		
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
