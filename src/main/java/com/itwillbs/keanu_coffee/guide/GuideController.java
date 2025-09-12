package com.itwillbs.keanu_coffee.guide;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class GuideController {
	
	
	@GetMapping("/guide")
	public String guide() {

		return "/guide/guide";
	}
}
