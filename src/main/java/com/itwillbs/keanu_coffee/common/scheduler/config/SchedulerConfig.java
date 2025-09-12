package com.itwillbs.keanu_coffee.common.scheduler.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
@EnableScheduling
public class SchedulerConfig {
	// @Scheduled 어노테이션을 사용할 수 있도록 스케줄링 기능을 켜줌
}
