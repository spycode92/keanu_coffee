package com.itwillbs.keanu_coffee.transport.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("transport")
public class TransportController {
	@GetMapping("/dashboard")
	public String dashboard() {
		return "/transport/dashboard";
	}
}
