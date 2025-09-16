package com.itwillbs.keanu_coffee.transport.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DriverVehicleDTO;
import com.itwillbs.keanu_coffee.transport.dto.VehicleDTO;
import com.itwillbs.keanu_coffee.transport.service.DispatchService;
import com.itwillbs.keanu_coffee.transport.service.DriverService;
import com.itwillbs.keanu_coffee.transport.service.RegionService;
import com.itwillbs.keanu_coffee.transport.service.VehicleService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("transport")
@RequiredArgsConstructor
public class TransportController {
	private final VehicleService vehicleService;
	private final DriverService driverService;
	private final RegionService regionService;
	private final DispatchService dispatchService;
	
	// 운송 대시보드
	@GetMapping("/main")
	public String dashboard(Model model) {
		// 배차대기(출고 요청) 요청 횟수
		Integer pendingDispatchCount = dispatchService.selectPendingDispatchCount();
		// 긴급 요청 
		Integer urgentDispatchCount = dispatchService.selectUrgentDispatchCount();
		// 기사의 상태별 횟수
		Map<String, Object> result = dispatchService.selectAssignmentStatusCount();
		
		// 운행중인 상태의 횟수
		Integer dispatchInProgressCount = ((Number) result.get("dispatchInProgressCount")).intValue();
		// 배차 완료인 상태의 횟수
		Integer dispatchCompletedCount = ((Number) result.get("dispatchCompletedCount")).intValue();
		
		// 배차 목록 (현재 날짜 기준)
		List<DispatchRegionGroupViewDTO> dispatchList = dispatchService.selectAllDispatchByToday();
		
		// 수주확인서 목록 
		List<Map<String, Object>> deliveryConfirmationList = dispatchService.selectAllDeliveryConfirmation();
		
		// 배차대기 횟수
		model.addAttribute("pendingDispatchCount", pendingDispatchCount);
		model.addAttribute("dispatchInProgressCount", dispatchInProgressCount);
		model.addAttribute("dispatchCompletedCount", dispatchCompletedCount);
		model.addAttribute("urgentDispatchCount", urgentDispatchCount);
		model.addAttribute("dispatchList", dispatchList);
		model.addAttribute("deliveryConfirmationList", deliveryConfirmationList);
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
	public String getAllDispatch(@RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "전체") String filter,
			@RequestParam(defaultValue = "") String searchKeyword,
			Model model) {
		
		int listLimit = 10;
		int listCount = dispatchService.getDispatchCount(filter, searchKeyword);
		
		if (listCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 10);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/transport/vehicle");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<DispatchRegionGroupViewDTO> dispatchList = dispatchService.selectAllDispatch(pageInfoDTO.getStartRow(), listLimit, filter, searchKeyword);
			
			model.addAttribute("dispatchList", dispatchList );
		}
		
		return "/transport/dispatche";
	}
	
	// 기사 마이페이지
	@GetMapping("/mypage/{id}")
	public String mypage(Authentication authentication, Model model) {
		EmployeeDetail empDetail = (EmployeeDetail)authentication.getPrincipal();
		
		// 기사 정보
		DriverVehicleDTO driverInfo = driverService.getDriver(empDetail.getEmpIdx());
		
		if (driverInfo == null) {
			model.addAttribute("msg", "기사 정보를 불러올 수 없습니다.");
			model.addAttribute("targetURL", "/transport/mypage");
			return "commons/result_process";
		}
		
		// 배차 정보 
		List<DispatchRegionGroupViewDTO> dispatchInfo = dispatchService.selectDispatchByVehicleIdx(driverInfo.getVehicleIdx());
		
		if (dispatchInfo == null) {
			model.addAttribute("msg", "배차 정보를 불러올 수 없습니다.");
			model.addAttribute("targetURL", "/transport/mypage");
			return "commons/result_process";
		}
		
		model.addAttribute("driverInfo", driverInfo);
		model.addAttribute("dispatchInfo", dispatchInfo);
		
		return "/transport/mypage";
	}
	
	// 구역관리 페이지
	@GetMapping("/region")
	public String region(Model model) {
		// 구역 리스트
		List<CommonCodeDTO> regionList = regionService.getRegionList();
		
		if (regionList == null) {
			model.addAttribute("msg", "지역 정보를 불러올 수 없습니다.");
			model.addAttribute("targetURL", "/transport/region");
			return "commons/result_process";
		}
		
		model.addAttribute("regionList", regionList);
		
		return "/transport/region";
	}
}
