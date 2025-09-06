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
	
	@GetMapping("inbound/{needData}")
		public ResponseEntity<List<TotalDashBoardDTO>> Dashboard(@PathVariable String needData,
				@RequestParam("startDate")String startDate, @RequestParam("endDate")String endDate) {
		System.out.println(startDate + "  " + endDate + "Dddddd");
		List<TotalDashBoardDTO> totalDList = totalDashBoardService.getInboundDashData(needData, startDate, endDate);
		
		return ResponseEntity.ok(totalDList);
	}
}
