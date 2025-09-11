package com.itwillbs.keanu_coffee.common.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.common.dto.AlarmDTO;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.service.AlarmService;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/alarm")
public class AlarmController {
	private final AlarmService alarmService;
	//알림 페이지이동
	@GetMapping("")
	public String alarmPage(Model model, Authentication authentication,
			@RequestParam(defaultValue = "1") int pageNum) {
		model.addAttribute("pageNum", pageNum);
		EmployeeInfoDTO employee = new EmployeeInfoDTO();
		EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
		String empNo = authentication.getName();
		Integer empIdx = empDetail.getEmpIdx();
		
		int listLimit = 10;
		int alarmCount = alarmService.getAlarmCount(empIdx);
		
		if(alarmCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, alarmCount, pageNum, 3);

			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/customer/notice_list");
				return "commons/result_process";
			}

			model.addAttribute("pageInfo", pageInfoDTO);
			List<AlarmDTO> alarmList = alarmService.getAlarm(empIdx, pageInfoDTO.getStartRow(),
					listLimit);
			model.addAttribute("alarmList", alarmList);
		} else {
			model.addAttribute("알림이 존재하지 않습니다");
		}
		
		
		
		
		
		return "commons/alarm";
	}
	
	
	//본인알림조회
	@GetMapping("/getAlarm")
	public ResponseEntity<List<AlarmDTO>> alarm(Authentication authentication) {
		EmployeeInfoDTO employee = new EmployeeInfoDTO();
		EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
		String empNo = authentication.getName();
		Integer empIdx = empDetail.getEmpIdx();
		List<AlarmDTO> alarmList = alarmService.getAlarmInAjax(empIdx);
		
		return ResponseEntity.ok(alarmList);
	}
	
	//알림상태변경
	@PostMapping("/status/{alarmIdx}/read")
	public ResponseEntity<Map<String, String>> alarmRead(@PathVariable Integer alarmIdx, Authentication authentication) {
		EmployeeInfoDTO employee = new EmployeeInfoDTO();
		EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
		String empNo = authentication.getName();
		Integer empIdx = empDetail.getEmpIdx();
		
		Boolean update = alarmService.modifyAlarmStatus(alarmIdx);
		Map<String, String> result = new HashMap<>();
		if(update) {
			result.put("message", "알림읽음 처리 완료");
		} else {
			result.put("message", "알림 읽음 처리 실패");
		}
		
		return ResponseEntity.ok(result);
	}
	
	
	
}
