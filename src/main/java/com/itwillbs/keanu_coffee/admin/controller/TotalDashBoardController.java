package com.itwillbs.keanu_coffee.admin.controller;

import java.util.Arrays;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/statistics")
public class TotalDashBoardController {
	
	@GetMapping("/1")
	public String Dashboard() {
		return "/admin/statistics/statistics1";
	}
	
	@GetMapping("/2")
	public String Dashboard2() {
		return "/admin/statistics/statistics2";
	}
}
