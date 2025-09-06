package com.itwillbs.keanu_coffee.admin.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.service.SystemNotificationService;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemnotification")
public class SystemNotificationController {
	private final SystemNotificationService systemNotificationService;

	@GetMapping("")
	public String workingLog(Model model, @RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchType, @RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "created_at") String orderKey, @RequestParam(defaultValue = "desc") String orderMethod) {
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("orderKey", orderKey);
		model.addAttribute("orderMethod", orderMethod);
		int listLimit = 10;

		int notiCount = systemNotificationService.getNoticeCount(searchType, searchKeyword);

		if (notiCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, notiCount, pageNum, 3);

			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/customer/notice_list");
				return "commons/result_process";
			}

			model.addAttribute("pageInfo", pageInfoDTO);

			List<SystemLogDTO> notificationList = systemNotificationService.getNotificationList(
					pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword, orderKey, orderMethod);
			model.addAttribute("notificationList", notificationList);
		}

		return "/admin/system_notification";
	}
}
