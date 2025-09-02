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
import com.itwillbs.keanu_coffee.common.aop.annotation.SystemLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.SystemLogTarget;
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
//	@Around("execution(* com.itwillbs.keanu_coffee.admin.service.*.insertEmployeeInfo(..))")
	
	//직원관리 - 직원추가 로그기록
	@Around("@annotation(systemLog)")
	public Object insertEmployeeLog(ProceedingJoinPoint pjp, SystemLog systemLog ) throws Throwable {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		SystemLogDTO slog = new SystemLogDTO();
		//시작시간
		long startTime = System.currentTimeMillis();

		//타겟테이블정보
		SystemLogTarget target = systemLog.target();
		slog.setTarget(target.name());

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
	        //여기부터 시작
	        if ("insertEmployeeInfo".equals(methodName)) {
	            EmployeeInfoDTO employee = (EmployeeInfoDTO) args[0];
	            slog.setSection("시스템설정");
	            slog.setSubSection("직원관리");
	            slog.setTargetIdx(employee.getEmpIdx());

	            if (errorMessage == null) {
	                slog.setLogMessage(
                		slog.getSection() + ">" + slog.getSubSection() + "에서"  + employee.getEmpNo() + employee.getEmpName() + " 직원추가 완료"
	                );
	            } else {
	                slog.setLogMessage(
                		slog.getSection() + ">" + slog.getSubSection() + "에서"  + employee.getEmpNo() + employee.getEmpName() + " 직원추가 중 오류 발생: " + errorMessage
	                );
	            }
	        }
	        
	        // 직원정보업데이트일때
	        if ("updateEmployeeInfo".equals(methodName)) {
	            EmployeeInfoDTO employee = (EmployeeInfoDTO) args[0];
	            slog.setSection("시스템설정");
	            slog.setSubSection("직원관리");
	            slog.setTargetIdx(employee.getEmpIdx());
	            if (errorMessage == null) {
	                slog.setLogMessage(
                		slog.getSection() + ">" + slog.getSubSection() + "에서" + employee.getEmpName() + " 직원정보 수정 완료"
	                );
	            } else {
	                slog.setLogMessage(
                		slog.getSection() + ">" + slog.getSubSection() + "에서" + employee.getEmpNo() + employee.getEmpName() + " 직원정보 수정 중 오류 발생: " + errorMessage
	                );
	            }
	        }
	        
	        //직원 비밀번호 초기화
	        if ("resetPw".equals(methodName)) {
				EmployeeInfoDTO employee = (EmployeeInfoDTO) args[0];
				employee = employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(employee.getEmpIdx());
				slog.setSection("시스템설정");
				slog.setSubSection("직원관리");
				slog.setTargetIdx(employee.getEmpIdx());
				if (errorMessage == null) {
					slog.setLogMessage(
							slog.getSection() + ">" + slog.getSubSection() + "에서"  + employee.getEmpNo() + employee.getEmpName() + " 직원비밀번호 초기화 완료"
							);
				} else {
					slog.setLogMessage(
							slog.getSection() + ">" + slog.getSubSection() + "에서" + employee.getEmpNo() + employee.getEmpName() + " 직원비밀번호 초기화 중 오류 발생: " + errorMessage
							);
				}
			}
	        
	        //직원 스스로 정보변경
	        if ("modifyEmployeeInfo".equals(methodName)) {
	        	EmployeeInfoDTO employee = (EmployeeInfoDTO) args[0];
	        	employee = employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(employee.getEmpIdx());
	        	slog.setSection("프로필정보");
	        	slog.setSubSection("정보수정");
	        	slog.setTargetIdx(employee.getEmpIdx());
	        	if (errorMessage == null) {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + "에서" + employee.getEmpNo() + employee.getEmpName() + "본인정보 수정 완료"
	        				);
	        	} else {
	        		slog.setLogMessage(
	        				slog.getSection() + ">" + slog.getSubSection() + "에서" + employee.getEmpNo() + employee.getEmpName() + "본인정보 수정 중 오류 발생: " + errorMessage
	        				);
	        	}
	        }
	        
	    	//지점관리 - 지점추가
	        if ("addFranchiseInfo".equals(methodName)) {
	        	FranchiseDTO franchise = (FranchiseDTO) args[0];
	        	slog.setSection("시스템설정");
	        	slog.setSubSection("지점관리");
				slog.setTargetIdx(franchise.getFranchiseIdx());
				if (errorMessage == null) {
					slog.setLogMessage(
						slog.getSection() + ">" + slog.getSubSection() + franchise.getFranchiseName() + " 지점 추가 완료"
					);
				} else {
					slog.setLogMessage(
						slog.getSection() + ">" + slog.getSubSection() + franchise.getFranchiseName() + " 지점 추가 중 오류 발생: " + errorMessage
					);
				}
	        }
	        
	        //지점관리 - 지점정보 수정 로그기록
	        if ("modifyFranchiseInfo".equals(methodName)) {
				FranchiseDTO franchise = (FranchiseDTO) args[0];
				slog.setSection("시스템설정");
				slog.setSubSection("지점관리");
				slog.setTargetIdx(franchise.getFranchiseIdx());
				if (errorMessage == null) {
					slog.setLogMessage(
						slog.getSection() + ">" + slog.getSubSection() + franchise.getFranchiseName() + " 지점정보 수정 완료"
					);
				} else {
					slog.setLogMessage(
						slog.getSection() + ">" + slog.getSubSection() + franchise.getFranchiseName() + " 지점정보 수정 중 오류 발생: " + errorMessage
					);
				}
			}
	        
	        
	        logmapper.insertSystemLog(slog);
	    }
			
		
		return result;
		
        
	}
	
	
	
	
	
	
	






}

