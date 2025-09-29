package com.itwillbs.keanu_coffee.demoData.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.demoData.dto.DemoDataDTO;
import com.itwillbs.keanu_coffee.demoData.service.DemoDataService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/Demo")
public class DemoDataController {
	private final DemoDataService demoDataService;
	
	
	
	// 더미데이터 생성 페이지 
	@GetMapping("")
	public String demoData () { 
	
		return "/dummyData/demo_DB";
	}
	
	@PostMapping("/makePO_IBW")
	public void makePO(@RequestBody DemoDataDTO demoData) {
		System.out.println(demoData.getStartDate());
		System.out.println(demoData.getEndDate());
		demoDataService.makePO(demoData);
	}
}
