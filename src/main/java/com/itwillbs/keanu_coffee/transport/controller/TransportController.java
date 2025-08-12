package com.itwillbs.keanu_coffee.transport.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("transport")
public class TransportController {
	// 운송 대시보드
	@GetMapping("")
	public String dashboard() {
		return "/transport/dashboard";
	}
	
	// 기사 목록 페이지
	@GetMapping("/drivers")
	public String driverList() {
		return "/transport/drivers";
	}
	
	// 차량 목록 페이지
	@GetMapping("/car")
	public String carList() {
		return "/transport/car";
	}
	
	// 배차 관리 페이지
	@GetMapping("/dispatches")
	public String dispatcheList() {
		return "/transport/dispatche";
	}
}
