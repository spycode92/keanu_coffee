package com.itwillbs.keanu_coffee.demoData.dto;

import java.time.LocalDate;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class DemoDataDTO {
	private LocalDate startDate;
	private LocalDate endDate;
	
}
