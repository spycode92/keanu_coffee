package com.itwillbs.keanu_coffee.admin.dto;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

import lombok.Data;

@Data
public class TotalDashBoardDTO {
	
	private String arrivalDate; 
	private String arrivalMonth;
	private String arrivalMonthWeek; 
	private String productName;
	private String categoryName;
	private Long IBWQuantity;
	private Long RIQuantity;
	private Long disposalQuantity;
	
    
    private List<CommonCodeDTO> commonCodeList;
}
