package com.itwillbs.keanu_coffee.common.aop.aspect;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.OrganizationMapper;
import com.itwillbs.keanu_coffee.admin.mapper.SupplyContractMapper;
import com.itwillbs.keanu_coffee.common.aop.annotation.WorkingLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.WorkingLogTarget;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.SystemLogDTO;
import com.itwillbs.keanu_coffee.common.mapper.LogMapper;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.TimeUtils;
import com.itwillbs.keanu_coffee.inbound.dto.ReceiptProductDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Aspect
@Component
@Log4j2
@RequiredArgsConstructor
public class WorkingLogAspect {
	private final EmployeeManagementMapper employeeManagementMapper;
	private final OrganizationMapper organizationMapper;
	private final SupplyContractMapper supplyContractMapper;
	private final LogMapper logmapper;
	
//	@Around("@annotation(com.itwillbs.keanu_coffee.common.aop.annotation.Insert)")
//	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.insertEmployeeInfo(..))")
	
	//직원관리 - 직원추가 로그기록
	@Around("@annotation(workingLog)")
	public Object insertEmployeeLog(ProceedingJoinPoint pjp, WorkingLog workingLog ) throws Throwable {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		SystemLogDTO slog = new SystemLogDTO();
		//시작시간
		long startTime = System.currentTimeMillis();

		//타겟테이블정보
		WorkingLogTarget target = workingLog.target();
		slog.setTarget(target.name());

		//작업자
		String empNo = authentication.getName();
		slog.setEmpNo(empNo);
		
		//작업로그지정
		slog.setSection("작업로그");
		
		Object result = null;
		String errorMessage = null;
		try {
		        result = pjp.proceed(); // 정상 실행
		} catch (Throwable ex) {
			errorMessage = ex.getMessage(); // 에러 메시지 저장
			// 필요하면 stack trace 등도 저장 가능
			throw ex; // 예외 다시 던져서 흐름 유지
		} finally {
			long endTime = System.currentTimeMillis();
	        long elapsedTime = endTime - startTime;
	        slog.setEmpNo(empNo);
	        slog.setStartTime(TimeUtils.formatMillisToLocalDateTime(startTime));
	        slog.setEndTime(TimeUtils.formatMillisToLocalDateTime(endTime));
	        slog.setElapsedTime(elapsedTime);

	        Object[] args = pjp.getArgs();
	        
	        for(int i = 0; i< args.length; i++) {
	        	System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ ");
	        	System.out.println("인덱스["+ i + "] :" + args[i]);
	        	System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ ");
	        }

	        String methodName = pjp.getSignature().getName();
	        //여기부터 시작
	        if (methodName.equals("updateReceiptProduct")) {
	            ReceiptProductDTO receiptProduct = (ReceiptProductDTO) args[0];
	            slog.setSubSection("입고처리");
//	            slog.setTargetIdx(receiptProduct.getReceiptProductIdx().intValue());
	            System.out.println(receiptProduct);
	            System.out.println(slog);
//	            if (errorMessage == null) {
//	                slog.setLogMessage(
//                		slog.getSection() + ">" + slog.getSubSection() + "에서"  + 
//                				receiptProduct.getEmpNo() + " "  + employee.getEmpName() + " 직원추가 완료"
//	                );
//	            } else {
//	                slog.setLogMessage(
//                		slog.getSection() + ">" + slog.getSubSection() + "에서"  + 
//                			employee.getEmpNo() + " " + employee.getEmpName() + " 직원추가 중 오류 발생: " + errorMessage
//	                );
//	            }
	        }
	        	        
//	        logmapper.insertSystemLog(slog);
	    }
			
		
		return result;
		
        
	}
	
	
	
	
	
	
	






}

