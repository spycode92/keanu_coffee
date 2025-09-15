package com.itwillbs.keanu_coffee.common.aop.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class QueryLoggingAspect {

    // log4j2 로거 생성 (log4j2.xml 설정 시 같은 이름 사용)
    private static final Logger logger = LogManager.getLogger("queryLogger");

    @Around("execution(* com.itwillbs.keanu_coffee..mapper.*.*(..))") // Mapper 위치에 맞게 수정
    public Object logQuery(ProceedingJoinPoint pjp) throws Throwable {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	String methodName = pjp.getSignature().getName();
        Object[] args = pjp.getArgs();
		String empNo = authentication.getName();

        logger.info("{} Use executing query method: {} with args {}", empNo, methodName, args);

        long startTime = System.currentTimeMillis();
        Object result = pjp.proceed();
        long endTime = System.currentTimeMillis();

        logger.info("Query method executed: {} in {}ms", methodName, (endTime - startTime));

        if (result instanceof Integer) {
            logger.info("Affected rows: {}", result);
        }



        return result;
    }
}
