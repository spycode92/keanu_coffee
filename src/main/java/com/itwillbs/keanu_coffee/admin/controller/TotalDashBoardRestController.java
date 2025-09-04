package com.itwillbs.keanu_coffee.admin.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.admin.service.TotalDashBoardService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/admin/dashboard")
public class TotalDashBoardRestController {
	private final TotalDashBoardService totalDashBoardService;
	
	@GetMapping("dayInbound")
	public ResponseEntity<List<TotalDashBoardDTO>> Dashboard() {
		TotalDashBoardDTO totalD = new TotalDashBoardDTO();
		List<TotalDashBoardDTO> totalDList = totalDashBoardService.getTotalDashBoardByDay();
		
		return ResponseEntity.ok(totalDList);
	}
}
