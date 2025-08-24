package com.itwillbs.keanu_coffee.admin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/employeeManagement")
public class EmployeeManagementController {
	private final EmployeeManagementService employeeManagementService;
	
	//관리자페이지 회원추가폼으로 이동
	@GetMapping("")
	public String employeeManagement(Model model, @RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue ="") String orderKey,
			@RequestParam(defaultValue ="") String orderMethod) {
		model.addAttribute("pageNum",pageNum);
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchKeyword",searchKeyword);
		model.addAttribute("sortKey",orderKey);
		model.addAttribute("sortMethod",orderMethod);
		
		switch (searchType) {
        case "이름":
            searchType = "emp_name";
            break;
        case "사번":
            searchType = "emp_no";
            break;
        case "아이디":
            searchType = "emp_id";
            break;
        default:
            searchType = ""; // 또는 기본값 설정
            break;
		}
		
		int listLimit = 10;
		int employeeCount = employeeManagementService.getEmployeeCount(searchType, searchKeyword);
		
		if (employeeCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, employeeCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/customer/notice_list");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
		
			List<EmployeeInfoDTO> employeeList = employeeManagementService.getEmployeeList(
					pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword, orderKey,orderMethod);
			model.addAttribute("employeeList", employeeList);
		}
		return "/admin/employee_management";
	}
	
	// 직원 정보 1명 불러오기 with idx
	@GetMapping("/getOneEmployeeInfo")
	@ResponseBody
	public EmployeeInfoDTO getOneEmployeeInfo(HttpSession session) {
		EmployeeInfoDTO employee = new EmployeeInfoDTO();
		employee.setEmpIdx((int)session.getAttribute("sIdx"));
		employee = employeeManagementService.getOneEmployeeInfoByEmpIdx(employee.getEmpIdx());
		
		return employee;
	}
	
	
	//직원추가 모달창 부서,팀,직책 정보 불러오기
	@GetMapping("/getOrgData")
	@ResponseBody
	public List<Map<String, Object>> getOrgData() {
		//부서별 팀.직책 데이터 구성
		List<Map<String, Object>> orgDataList = employeeManagementService.getOrgData();
		System.out.println(orgDataList);
		return orgDataList;
	}
	
		
	
	//관리자페이지 회원추가 로직
	@PostMapping("/addEmployee")
	public String addEmployeeForm(EmployeeInfoDTO employee, Model model) throws IOException {
		
		int inputCount = employeeManagementService.inputEmployeeInfo(employee);
		if (inputCount == 0) {
			model.addAttribute("msg", "추가실패");
		}
		model.addAttribute("msg", "추가완료");
		model.addAttribute("targetURL", "/admin/employeeManagement/addEmployeeForm"); 
		return "redirect:/admin/employeeManagement";
//		return "";
	}
	
	//직원 개인정보 변경로직
	@PostMapping("/modifyEmployeeInfo")
	public String modifyEmployeeInfo(EmployeeInfoDTO employee, HttpServletRequest request, HttpSession session) throws IllegalStateException, IOException {
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println(employee);
		System.out.println(employee.getFiles()[0]);
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		int updateCount = employeeManagementService.modifyEmployeeInfo(employee);
		String refererUrl = request.getHeader("Referer");
				
		if (refererUrl != null && !refererUrl.isEmpty()) {
	        return "redirect:" + refererUrl;
	    } else {
	        return "redirect:/";  // 기본 홈페이지로
	    }
	}
	
	
	
	
}
