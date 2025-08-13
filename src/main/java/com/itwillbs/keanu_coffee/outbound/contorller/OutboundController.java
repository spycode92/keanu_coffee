package com.itwillbs.keanu_coffee.outbound.contorller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/outbound")
public class OutboundController {
	
	@GetMapping("/main")
	public String showOutboundDashboard() {
	    return "/outbound/outboundDashboard";
	}
	
	@GetMapping("/outboundManagement")
	public String showOutboundManagement() {
	    return "/outbound/outboundManagement";
	}
	
}
