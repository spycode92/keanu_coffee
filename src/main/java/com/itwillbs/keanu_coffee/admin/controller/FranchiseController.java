package com.itwillbs.keanu_coffee.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.service.FranchiseService;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/franchise")
public class FranchiseController {
	private final FranchiseService franchiseService;
	
	@GetMapping("")
	public String franchiseManagement(Model model, @RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "") String orderKey,
			@RequestParam(defaultValue = "") String orderMethod) {
		
		model.addAttribute("pageNum",pageNum);
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchKeyword",searchKeyword);
		model.addAttribute("sortKey",orderKey);
		model.addAttribute("sortMethod",orderMethod);
		
		//한페이지보여줄수
		int listLimit = 10;
		// 조회된 목록수
		int franchiseCount = franchiseService.getFranchiseCount(searchType, searchKeyword);
		// 조회된 목록이 1개이상일때
		if(franchiseCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, franchiseCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/customer/notice_list");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
		
			List<FranchiseDTO> franchiseList = franchiseService.getFranchiseList(
				pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword, orderKey,orderMethod);
			model.addAttribute("franchiseList",franchiseList);
		}
		
		return "/admin/system_preference/franchise_management";
	}
	
	//지점 등록
	@PostMapping("/addFranchise")
	@ResponseBody
	public FranchiseDTO addFranchiseInfo(@RequestBody FranchiseDTO franchise) {
		franchiseService.addFranchiseInfo(franchise);
		return franchise;
	}
	
	//지점상세보기
	@GetMapping("/{franchiseIdx}")
	@ResponseBody
	public FranchiseDTO getFranchiseDetail(@PathVariable Integer franchiseIdx) {
		FranchiseDTO franchise = franchiseService.getFranchiseDetail(franchiseIdx);
		return franchise;
	}
	
	//지점정보 업데이트
	@PutMapping("/modifyFranchise")
	@ResponseBody
	public ResponseEntity<Map<String,String>> modifyFranchiseInfo(@RequestBody FranchiseDTO franchise) {
		Map<String, String> resultMap = new HashMap<String, String>();
		int updateCount = franchiseService.modifyFranchiseInfo(franchise);
		if(updateCount == 0) {
			resultMap.put("result", "failure");
            resultMap.put("msg", "지점 정보 수정실패!");
            return ResponseEntity.badRequest().body(resultMap);
		}

		resultMap.put("result", "success");
		resultMap.put("msg", "지점 정보 수정 완료!");
		return ResponseEntity.ok(resultMap);
		
	}
	
}

































