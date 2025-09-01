package com.itwillbs.keanu_coffee.admin.aop;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j2;

@Aspect
@Component
@Log4j2
public class AdminAop {
	
	@Before("execution(* com.itwillbs.keanu_coffee.admin.controller.AdminController.*(..))")
	public void showLog() {
	    log.info("AOP 동작 테스트: AdminController 모든 메서드 진입");
	}
	
	@Before("execution(* com.itwillbs.keanu_coffee.admin.controller.AdminController.*(..))")
	public void showLog2() {
	    System.out.println(">>> AOP 테스트: AdminController 메서드 진입");
	    log.info("AOP 동작 테스트: AdminController 모든 메서드 진입");
	}
	
}
