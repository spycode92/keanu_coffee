package com.itwillbs.keanu_coffee.common.utils;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.keanu_coffee.common.dto.SweetAlertIcon;

public class MakeAlert {
	public static void makeAlert(RedirectAttributes redirectAttributes, SweetAlertIcon icon, String title, String msg) {
	    redirectAttributes.addFlashAttribute("icon", icon.getValue());
	    redirectAttributes.addFlashAttribute("title", title);
	    redirectAttributes.addFlashAttribute("msg", msg);
	}
}
