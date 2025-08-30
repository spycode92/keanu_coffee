package com.itwillbs.keanu_coffee.transport.controller;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
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
		} catch (DuplicateKeyException e) {
			redirectAttributes.addFlashAttribute("msg", e.getMessage());
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("msg", "구역 등록 중 오류가 발생했습니다.");
		}
		
		return "redirect:/transport/region";
	}
	
	// 구역 이름 수정
	@PostMapping("/region/edit")
	public String editRegion(@RequestBody CommonCodeDTO request, RedirectAttributes redirectAttributes) {
		try {
			regionService.modifyRegion(request.getCommonCodeIdx(), request.getCommonCodeName());
		} catch (DuplicateKeyException e) {
			redirectAttributes.addFlashAttribute("msg", e.getMessage());
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("msg", "수정 중 오류가 발생했습니다..");
		}
		return "redirect:/transport/region";
	}
	
	// 구역 삭제
	@PostMapping("/region/delete")
	public ResponseEntity<?> deleteRegion(@RequestBody CommonCodeDTO request) {
		try {
			regionService.removeRegion(request.getCommonCodeIdx());
			return ResponseEntity.ok("구역이 삭제되었습니다.");
		} catch (IllegalStateException e) {
			return ResponseEntity.badRequest().
					contentType(MediaType.valueOf("application/json; charset=UTF-8"))
					.body(e.getMessage());
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("구역 삭제 중 오류가 발생했습니다.");
		}
	}
}
