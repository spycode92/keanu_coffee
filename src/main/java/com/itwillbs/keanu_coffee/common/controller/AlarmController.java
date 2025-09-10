package com.itwillbs.keanu_coffee.common.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AlarmController {
	@GetMapping("/alarm")
	public String alarm(Model model, Principal principal) {
		
		
		return "/commons/alarm"; 
	}
}
