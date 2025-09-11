package com.itwillbs.keanu_coffee.admin.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.dto.SweetAlertIcon;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.MakeAlert;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/employeeManagement")
public class EmployeeManagementController {
	private final EmployeeManagementService employeeManagementService;

	// 직원관리페이지
	@GetMapping("")
	public String employeeManagement(Model model, @RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchType, @RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "") String orderKey, @RequestParam(defaultValue = "") String orderMethod) {
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("orderKey", orderKey);
		model.addAttribute("orderMethod", orderMethod);

		switch (searchType) {
		case "이름":
			searchType = "emp_name";
			break;
		case "사번":
			searchType = "emp_no";
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

			List<EmployeeInfoDTO> employeeList = employeeManagementService.getEmployeeList(pageInfoDTO.getStartRow(),
					listLimit, searchType, searchKeyword, orderKey, orderMethod);
			model.addAttribute("employeeList", employeeList);
		}	

		return "/admin/employee_management";
	}

	// 자기정보 불러오기
	@GetMapping("/getOneEmployeeInfo")
	@ResponseBody
	public EmployeeInfoDTO getOneEmployeeInfo(HttpSession session, Authentication authentication) {
		EmployeeInfoDTO employee = new EmployeeInfoDTO();
		EmployeeDetail empDetail = (EmployeeDetail) authentication.getPrincipal();
		String empNo = authentication.getName();
		Integer empIdx = empDetail.getEmpIdx();

		employee = employeeManagementService.getOneEmployeeInfoByEmpIdx(empIdx);
		return employee;
	}

	// 개인정보 변경로직
	@PostMapping("/modifyEmployeeInfo")
	public String modifyEmployeeInfo(EmployeeInfoDTO employee, HttpServletRequest request,
			Authentication authentication) throws IllegalStateException, IOException {
		int updateCount = employeeManagementService.modifyEmployeeInfo(employee, authentication);
		String refererUrl = request.getHeader("Referer");

		if (refererUrl != null && !refererUrl.isEmpty()) {
			return "redirect:" + refererUrl;
		} else {
			return "redirect:/"; // 기본 홈페이지로
		}
	}

	// 직원추가 모달창 부서,팀,직책 정보 불러오기
	@GetMapping("/getOrgData")
	@ResponseBody
	public List<Map<String, Object>> getOrgData() {
		// 부서별 팀.직책 데이터 구성
		List<Map<String, Object>> orgDataList = employeeManagementService.getOrgData();
		return orgDataList;
	}

	// 직원추가 모달창 직원추가 로직
	@PostMapping("/addEmployee")
	public String addEmployeeForm(EmployeeInfoDTO employee, Model model, RedirectAttributes redirectAttributes)
			throws IOException {
		int inputCount = employeeManagementService.insertEmployeeInfo(employee);
		if (inputCount == 0) {
			MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.ERROR, "실패", "직원추가실패");
		}
		MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.SUCCESS, "성공", "직원추가완료");
		return "redirect:/admin/employeeManagement";
	}

	// 직원 정보 조회
	@GetMapping("/getEmployeeDetailByIdx")
	@ResponseBody
	public EmployeeInfoDTO getEmployeeDetailByIdx(EmployeeInfoDTO employee) {

		employee = employeeManagementService.getOneEmployeeInfoByEmpIdx(employee.getEmpIdx());

		return employee;
	}

	// 직원 정보 수정
	@PostMapping("/updateEmployee")
	public String updateEmployee(EmployeeInfoDTO employee, RedirectAttributes redirectAttributes) {
		employeeManagementService.updateEmployeeInfo(employee);
		MakeAlert.makeAlert(redirectAttributes, SweetAlertIcon.SUCCESS, "성공", "직원 정보 수정 완료");

		return "redirect:/admin/employeeManagement";
	}

	// 직원 비밀번호 초기화(1234)
	@PostMapping("/resetPw")
	@ResponseBody
	public Map<String, Object> resetPw(@RequestBody EmployeeInfoDTO employee) {
		System.out.println(employee);
		// AJAX결과 리턴 객체 생성
		Map<String, Object> result = new HashMap<>();

		int updateCount = employeeManagementService.resetPw(employee);

		result.put("success", updateCount > 0);

		return result;

	}

}
