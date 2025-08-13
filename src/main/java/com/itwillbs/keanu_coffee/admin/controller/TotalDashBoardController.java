package com.itwillbs.keanu_coffee.admin.controller;

import java.util.Arrays;

import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/dashboard")
public class TotalDashBoardController {
	@GetMapping("")
	public String Dashboard(Model model) {
		
		
		return "/admin/dashboard";
	}
}
