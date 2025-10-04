package com.itwillbs.keanu_coffee.common.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class DisposalDTO {
	private Integer disposalIdx;
	private Integer empIdx;
	private Integer receiptProductIdx;   // 상품번호
	private String section;              //  공정
	private Integer disposalAmount;      //  폐기수량
	private String note;                 //  폐기 사유
	private Timestamp createdAt;         //  생성일      
}
