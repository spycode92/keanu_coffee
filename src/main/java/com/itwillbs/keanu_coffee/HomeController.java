package com.itwillbs.keanu_coffee;

import java.util.Locale;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.itwillbs.keanu_coffee.admin.service.LoginService;
import com.itwillbs.keanu_coffee.common.controller.RedirectDecider;

import lombok.RequiredArgsConstructor;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequiredArgsConstructor
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private final LoginService loginService;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, Authentication authentication) {
		
		if(authentication == null || authentication.getName().equals("")) {
			return "home";
		}
		
		RedirectDecider redirectDecider = new RedirectDecider();
		String redirectURL = redirectDecider.decideRedirectUrl(authentication);
		return "redirect:" + redirectURL;
	}
	
	
}
