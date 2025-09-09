package com.itwillbs.keanu_coffee.admin.dto;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

import lombok.Data;

@Data
public class TotalDashBoardDTO {
	// 입고
	private String arrivalDate; // 입고도착일 
	private String arrivalMonth; // 입고도착월
	private String arrivalMonthWeek; //입고도착주
	
	private Long IBWQuantity; // 입고대기수량 
	private Long RIQuantity; // 입고완료수량
	
	// 운송출고
	private String transportDate; //배송도착일
	private String transportWeek;// 배송도착주
	private String transportMonth; //배송도착월
	
	private Long OBOQuantity; // 출고주문수량
	private Long DIQuantity; //배송완료 수량
	
	//폐기량
	private String disposalDate; //폐기일
	private String disposalWeek; //폐기주
	private String disposalMonth; //폐기월
	
	private String section; //공정
	
	//재고
	private Long inventoryQTY;
	
	//창고
	private String rack;
	private String bay;
	private String levelPosition;
	private int locationType;
	private long locationVolume;
	private long productVolume;
	
	
    

	private String productName; // 상품이름
	private String categoryName; // 카테고리이름
	private Long disposalQuantity; //폐기수량

	private List<CommonCodeDTO> commonCodeList;
}
