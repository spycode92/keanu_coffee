package com.itwillbs.keanu_coffee.transport.controller;

import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.transport.dto.AdministrativeRegionDTO;
import com.itwillbs.keanu_coffee.transport.dto.MappingDTO;
import com.itwillbs.keanu_coffee.transport.dto.RegionFranchiseRouteDTO;
import com.itwillbs.keanu_coffee.transport.service.RegionService;
import com.itwillbs.keanu_coffee.transport.service.RouteService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("transport")
@RequiredArgsConstructor
public class RegionController {
	private final RegionService regionService;
	private final RouteService routeService;
	
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
	@ResponseBody
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
	
	// 행정구역 리스트 
	@GetMapping("/administrativeRegions")
	@ResponseBody
	public List<AdministrativeRegionDTO> getAdministrativeRegions() {
		return regionService.getAdministrativeRegionList();
	}
	
	// 주소 매핑
	@PostMapping("/mapping/add")
	@ResponseBody
	public ResponseEntity<?> addMapping(@RequestBody MappingDTO mapping) {
		try {
			regionService.addMapping(mapping);
			return ResponseEntity.ok("매핑 등록 성공");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("매핑 등록 중 오류 발생: " + e.getMessage());
		}
	}
	
	// 구역별 행정구역 리스트
	@GetMapping("/mapping/region")
	@ResponseBody
	public List<MappingDTO> mappingRegionList() {
		return regionService.getMappingRegionList();
	}
	
	// 매핑된 행정구역 삭제
	@PostMapping("/mapping/delete")
	@ResponseBody
	public ResponseEntity<?> deleteMapping(@RequestBody Integer idx) {
		try {
			regionService.removeMapping(idx);
			return ResponseEntity.ok("매핑 삭제 성공");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("매핑 삭제 중 오류 발생: " + e.getMessage());
		}
	}
	
	// 매핑된 행정구역 그룹 삭제
	@PostMapping("/mappingGroup/delete")
	@ResponseBody
	public ResponseEntity<?> deleteAllMapping(@RequestBody List<Integer> idxList) {
		try {
			regionService.removeAllMapping(idxList);
			return ResponseEntity.ok("매핑 삭제 성공");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("매핑 삭제 중 오류 발생: " + e.getMessage());
		}
	}
	
	// 행정구역별 지점 순서 리스트
	@GetMapping("/franchise/route")
	@ResponseBody
	public List<RegionFranchiseRouteDTO> franchiseRoute() {
		return routeService.getFranchiseRouteList();
	}
	
	// 지점 배송 순서 변경
	@PostMapping("/franchise/reorder")
	@ResponseBody
	public ResponseEntity<?> reorderRoutes(@RequestBody List<RegionFranchiseRouteDTO> franchiseOrders) {
		try {
			routeService.reorderRoutes(franchiseOrders);
			 return ResponseEntity.ok("순서 저장 완료");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("순서 변경 중 오류 발생: " + e.getMessage());
		}
	}
}
