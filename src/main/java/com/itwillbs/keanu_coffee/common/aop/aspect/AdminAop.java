package com.itwillbs.keanu_coffee.common.aop.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.TimeUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Aspect
@Component
@Log4j2
@RequiredArgsConstructor
public class AdminAop {
	private final EmployeeManagementMapper employeeManagementMapper;
	
	@After("execution(* com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService.*(..))")
	public void showLog(JoinPoint joinPoint) {
		long startTime = System.currentTimeMillis();
//		System.out.println(startTime);
//		
//		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//		EmployeeDetail empDetail = (EmployeeDetail)authentication.getPrincipal();
//		log.info("AOP 동작 After@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
//		//작업사원정보가져오기
//		EmployeeInfoDTO employee = employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(empDetail.getEmpIdx());
//		System.out.println(employee);
//		System.out.println("사원이름 : " + employee.getEmpName());
//		System.out.println("사원번호 : " + employee.getEmpNo());
//		System.out.println("소속 부서 : " + employee.getCommonCode().getCommonCodeName());
//		System.out.println("소속 팀 : " + employee.getTeam().getTeamName());
//		System.out.println("직책 : " + employee.getRole().getRoleName());
//		log.info("사번 : " + authentication.getName());
//		log.info("권한 : " + authentication.getAuthorities());
//		log.info("empIdx : " + empDetail.getEmpIdx());
//		log.info("사원 : " + empDetail.getEmpName());
//		
//		//사용클래스, 메서드 정보가져오기
//		String methodName = joinPoint.getSignature().getName();
//        String className = joinPoint.getTarget().getClass().getSimpleName();
//        Object[] args = joinPoint.getArgs();
//        
//        System.out.println("=== Insert 로그 ===");
//        System.out.println("실행된 클래스: " + className);
//        System.out.println("실행된 메서드: " + methodName);
//        System.out.println("입력 파라미터 개수: " + args.length);
//        for (int i = 0; i < args.length; i++) {
//            Object arg = args[i];
//            System.out.println("파라미터 " + (i+1) + ": " + arg);
//        }
	}
	
//	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService.*(..))")
	
	
	
}

