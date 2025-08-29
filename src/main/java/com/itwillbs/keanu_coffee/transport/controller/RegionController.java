package com.itwillbs.keanu_coffee.transport.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.transport.service.RegionService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("transport")
@RequiredArgsConstructor
public class RegionController {
	private final RegionService regionService;
	
	// 구역 등록
	@PostMapping("/region/add")
	public String addRegion(@RequestParam String regionName, RedirectAttributes redirectAttributes) {
		try {
			regionService.addRegion(regionName);
			redirectAttributes.addFlashAttribute("msg", "구역이 등록되었습니다.");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("msg", "구역 등록 중 오류가 발생했습니다.");
		}
		
		return "redirect:/transport/region";
	}
}
