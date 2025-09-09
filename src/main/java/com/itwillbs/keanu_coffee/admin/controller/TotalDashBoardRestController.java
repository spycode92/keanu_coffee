package com.itwillbs.keanu_coffee.admin.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.admin.service.TotalDashBoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/dashboard")
@Log4j2
public class TotalDashBoardRestController {
	private final TotalDashBoardService totalDashBoardService;
	
	// 입고차트 필요한정보 불러오기
	@GetMapping("inbound/{needData}")
		public ResponseEntity<List<TotalDashBoardDTO>> inbound(@PathVariable String needData,
				@RequestParam("startDate")String startDate, @RequestParam("endDate")String endDate) {
		List<TotalDashBoardDTO> totalDList = totalDashBoardService.getInboundDashData(needData, startDate, endDate);
		
		return ResponseEntity.ok(totalDList);
	}
	// 출고차트 필요한정보 불러오기
	@GetMapping("outbound/{needData}")
	public ResponseEntity<List<TotalDashBoardDTO>> outbound(@PathVariable String needData,
			@RequestParam("startDate")String startDate, @RequestParam("endDate")String endDate) {
		List<TotalDashBoardDTO> totalDList = totalDashBoardService.getOutboundDashData(needData, startDate, endDate);
		
		return ResponseEntity.ok(totalDList);
	}
	// 폐기차트 필요한정보 불러오기
	@GetMapping("disposal/{needData}")
	public ResponseEntity<List<TotalDashBoardDTO>> didsposal(@PathVariable String needData,
			@RequestParam("startDate")String startDate, @RequestParam("endDate")String endDate) {
		List<TotalDashBoardDTO> totalDList = totalDashBoardService.getDisposalDashData(needData, startDate, endDate);
		
		return ResponseEntity.ok(totalDList);
	}
	// 폐기차트 필요한정보 불러오기
	@GetMapping("/inventory")
	public ResponseEntity<List<TotalDashBoardDTO>> inventory() {
		List<TotalDashBoardDTO> totalDList = totalDashBoardService.getInventoryDashData();
		
		return ResponseEntity.ok(totalDList);
	}
	//용적율 정보
	@GetMapping("/locationUse")
	public ResponseEntity<List<TotalDashBoardDTO>> location() {
		List<TotalDashBoardDTO> totalDList = totalDashBoardService.getLocationDashData();
		
		return ResponseEntity.ok(totalDList);
	}
}
























