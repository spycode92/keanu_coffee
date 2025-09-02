package com.itwillbs.keanu_coffee.common.aop.aspect;

import java.sql.Timestamp;

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

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.common.mapper.LogMapper;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.TimeUtils;
import com.itwillbs.keanu_coffee.log.dto.SystemLogDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Aspect
@Component
@Log4j2
@RequiredArgsConstructor
public class SystemLogAspect {
	private final EmployeeManagementMapper employeeManagementMapper;
	private final LogMapper logmapper;
	
//	@Around("@annotation(com.itwillbs.keanu_coffee.common.aop.annotation.Insert)")
	
	//직원관리 - 직원추가 로그기록
	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.insertEmployeeInfo(..))")
	public Object insertEmployeeLog(ProceedingJoinPoint pjp ) throws Throwable {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		//시작시간
		long startTime = System.currentTimeMillis();

		SystemLogDTO slog = new SystemLogDTO();
		//작업자
		String empNo = authentication.getName();
		slog.setEmpNo(empNo);
		
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

	        String methodName = pjp.getSignature().getName();
	        if ("insertEmployeeInfo".equals(methodName)) {
	            EmployeeInfoDTO employee = (EmployeeInfoDTO) args[0];
	            slog.setSection("시스템설정");
	            slog.setSubSection("직원관리");
	            slog.setTarget("EMPLOYEE_INFO");
	            slog.setTargetIdx(employee.getEmpIdx());

	            if (errorMessage == null) {
	                slog.setLogMessage(
	                    "시스템 설정 > 직원관리 에서 " + employee.getEmpNo() + employee.getEmpName() + " 직원추가 완료"
	                );
	            } else {
	                slog.setLogMessage(
	                    "시스템 설정 > 직원관리 에서 " + employee.getEmpNo() + employee.getEmpName() + " 직원추가 중 오류 발생: " + errorMessage
	                );
	            }
	        }
	        logmapper.insertSystemLog(slog);
	    }
			
		
		return result;
		
        
	}
	
	//직원관리 - 직원정보수정 로그기록
	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.updateEmployeeInfo(..))")
	public Object updateEmployeeLog(ProceedingJoinPoint pjp ) throws Throwable {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

		//시작시간
		long startTime = System.currentTimeMillis();

		SystemLogDTO slog = new SystemLogDTO();
		//작업자
		String empNo = authentication.getName();
		slog.setEmpNo(empNo);
		
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

	        String methodName = pjp.getSignature().getName();
	        if ("updateEmployeeInfo".equals(methodName)) {
	            EmployeeInfoDTO employee = (EmployeeInfoDTO) args[0];
	            slog.setSection("시스템설정");
	            slog.setSubSection("직원관리");
	            slog.setTarget("EMPLOYEE_INFO");
	            slog.setTargetIdx(employee.getEmpIdx());
	            if (errorMessage == null) {
	                slog.setLogMessage(
	                    "시스템 설정 > 직원관리 에서 " + employee.getEmpNo() + employee.getEmpName() + " 직원정보 수정 완료"
	                );
	            } else {
	                slog.setLogMessage(
	                    "시스템 설정 > 직원관리 에서 " + employee.getEmpNo() + employee.getEmpName() + " 직원정보 수정 중 오류 발생: " + errorMessage
	                );
	            }
	        }
	        logmapper.insertSystemLog(slog);
	    }
		
		return result;
	}
	
	//직원관리 - 비밀번호초기화 로그기록
	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.resetPw(..))")
	public Object resetPwLog(ProceedingJoinPoint pjp ) throws Throwable {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		//시작시간
		long startTime = System.currentTimeMillis();
		
		SystemLogDTO slog = new SystemLogDTO();
		//작업자
		String empNo = authentication.getName();
		slog.setEmpNo(empNo);
		
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
			
			String methodName = pjp.getSignature().getName();
			if ("resetPw".equals(methodName)) {
				EmployeeInfoDTO employee = (EmployeeInfoDTO) args[0];
				employee = employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(employee.getEmpIdx());
				slog.setSection("시스템설정");
				slog.setSubSection("직원관리");
				slog.setTarget("EMPLOYEE_INFO");
				slog.setTargetIdx(employee.getEmpIdx());
				if (errorMessage == null) {
					slog.setLogMessage(
							"시스템 설정 > 직원관리 에서 " + employee.getEmpNo() + employee.getEmpName() + " 직원비밀번호 초기화 완료"
							);
				} else {
					slog.setLogMessage(
							"시스템 설정 > 직원관리 에서 " + employee.getEmpNo() + employee.getEmpName() + " 직원비밀번호 초기화 중 오류 발생: " + errorMessage
							);
				}
			}
			logmapper.insertSystemLog(slog);
		}
		
		return result;
	}
	
	//지점관리 - 지점추가
	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.addFranchiseInfo(..))")
	public Object addFranchiseLog(ProceedingJoinPoint pjp ) throws Throwable {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		//시작시간
		long startTime = System.currentTimeMillis();
		
		SystemLogDTO slog = new SystemLogDTO();
		//작업자
		String empNo = authentication.getName();
		slog.setEmpNo(empNo);
		
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
	        for (int i = 0; i < args.length; i++) {
	            System.out.println("arg[" + i + "]: " + args[i]);
	        }
			String methodName = pjp.getSignature().getName();
			if ("addFranchiseInfo".equals(methodName)) {
				FranchiseDTO franchise = (FranchiseDTO) args[0];
				slog.setSection("시스템설정");
				slog.setSubSection("지점관리");
				slog.setTarget("FRANCHISE");
				slog.setTargetIdx(franchise.getFranchiseIdx());
				if (errorMessage == null) {
					slog.setLogMessage(
							"시스템 설정 > 지점관리 에서 " + franchise.getFranchiseName() + " 지점 추가 완료"
							);
				} else {
					slog.setLogMessage(
							"시스템 설정 > 지점관리 에서 " + franchise.getFranchiseName() + " 지점 추가 중 오류 발생: " + errorMessage
							);
				}
			}
			logmapper.insertSystemLog(slog);
		}
		
		return result;
	}
	
	
	//지점관리 - 지점정보 수정 로그기록
	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.modifyFranchiseInfo(..))")
	public Object updateFranchiseLog(ProceedingJoinPoint pjp ) throws Throwable {
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		//시작시간
		long startTime = System.currentTimeMillis();
		
		SystemLogDTO slog = new SystemLogDTO();
		//작업자
		String empNo = authentication.getName();
		slog.setEmpNo(empNo);
		
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
			for (int i = 0; i < args.length; i++) {
				System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
				System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
				System.out.println("arg[" + i + "]: " + args[i]);
				System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
				System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
			}
			String methodName = pjp.getSignature().getName();
			if ("modifyFranchiseInfo".equals(methodName)) {
				FranchiseDTO franchise = (FranchiseDTO) args[0];
				slog.setSection("시스템설정");
				slog.setSubSection("지점관리");
				slog.setTarget("FRANCHISE");
				slog.setTargetIdx(franchise.getFranchiseIdx());
				if (errorMessage == null) {
					slog.setLogMessage(
							"시스템 설정 > 지점관리 에서 " + franchise.getFranchiseName() + " 지점정보 수정 완료"
							);
				} else {
					slog.setLogMessage(
							"시스템 설정 > 지점관리 에서 " + franchise.getFranchiseName() + " 지점정보 수정 중 오류 발생: " + errorMessage
							);
				}
			}
			logmapper.insertSystemLog(slog);
		}
		
		return result;
	}
	
	
	






}

