package com.itwillbs.keanu_coffee.inbound.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound")
public class InboundController {
	
	@GetMapping("/main")
	public String showJoinTypePage() {
	    return "/inbound/inboundManagement";
	}
	
}
