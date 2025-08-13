package com.itwillbs.keanu_coffee.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("admin/workingLog")
public class WorkinglogController {

	@GetMapping("")
	public String workingLog() {
		return "/admin/working_log";
	}
}
