package com.itwillbs.keanu_coffee.common.aop.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.itwillbs.keanu_coffee.common.aop.targetEnum.SystemLogTarget;

@Retention(RetentionPolicy.RUNTIME) // 대상이 실행되는 시점에 동작하는 어노테이션으로 지정
@Target(ElementType.METHOD)
public @interface SystemLog {
	
	SystemLogTarget target(); 
}
