package com.itwillbs.keanu_coffee.demoData.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.demoData.service.DemoDataService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/Demo")
public class DemoDataController {
	private final DemoDataService demoDataService;
	
	
	@GetMapping("/make")
	public void makedata () { 
		demoDataService.makeData();
	}
}
