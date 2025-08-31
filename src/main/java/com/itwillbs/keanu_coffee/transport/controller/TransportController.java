package com.itwillbs.keanu_coffee.transport.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;
import com.itwillbs.keanu_coffee.transport.dto.AdministrativeRegionDTO;
import com.itwillbs.keanu_coffee.transport.dto.DriverVehicleDTO;
import com.itwillbs.keanu_coffee.transport.dto.RegionFranchiseRouteDTO;
import com.itwillbs.keanu_coffee.transport.dto.VehicleDTO;
import com.itwillbs.keanu_coffee.transport.service.DriverService;
import com.itwillbs.keanu_coffee.transport.service.RegionService;
import com.itwillbs.keanu_coffee.transport.service.RouteService;
import com.itwillbs.keanu_coffee.transport.service.VehicleService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("transport")
@RequiredArgsConstructor
public class TransportController {
	private final VehicleService vehicleService;
	private final DriverService driverService;
	private final RegionService regionService;
	
	// 운송 대시보드
	@GetMapping("")
	public String dashboard() {
		return "/transport/dashboard";
	}
	
	// 기사 목록 페이지
	@GetMapping("/drivers")
	public String driverList(
			@RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "all") String filter,
			@RequestParam(defaultValue = "") String searchKeyword,
			Model model) {
		int listLimit = 10;
		int listCount = driverService.getDriverCount(filter, searchKeyword);
		
		if (listCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 10);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/transport/drivers");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<DriverVehicleDTO> driverList = driverService.getDriverList(pageInfoDTO.getStartRow(), listLimit, filter, searchKeyword);
			
			model.addAttribute("driverList", driverList );
		}
		return "/transport/drivers";
	}
	
	// 차량 목록 페이지
	@GetMapping("/vehicle")
	public String carList(
			@RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "all") String filter,
			@RequestParam(defaultValue = "") String searchKeyword,
			Model model) {
		
		int listLimit = 10;
		int listCount = vehicleService.getVehicleCount(filter, searchKeyword);
		
		if (listCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 10);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/transport/vehicle");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<VehicleDTO> vehicleList = vehicleService.getVehicleList(pageInfoDTO.getStartRow(), listLimit, filter, searchKeyword);
			
			// 차량 리스트
//			System.out.println(vehicleList);
			
			model.addAttribute("vehicleList", vehicleList );
		}
		return "/transport/vehicle";
	}
	
	// 배차 관리 페이지
	@GetMapping("/dispatches")
	public String dispatcheList() {
		return "/transport/dispatche";
	}
	
	// 기사 마이페이지
	@GetMapping("/mypage")
	public String mypage() {
		return "/transport/mypage";
	}
	
	// 구역관리 페이지
	@GetMapping("/region")
	public String region(Model model) {
		// 구역 리스트
		List<CommonCodeDTO> regionList = regionService.getRegionList();
		
		if (regionList == null) {
			model.addAttribute("msg", "지역 정보를 불러올 수 없습니다.");
			model.addAttribute("targetURL", "/region");
			return "commons/result_process";
		}
		
		model.addAttribute("regionList", regionList);
		
		return "/transport/region";
	}
}
