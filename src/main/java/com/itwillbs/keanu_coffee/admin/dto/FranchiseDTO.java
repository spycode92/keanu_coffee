package com.itwillbs.keanu_coffee.admin.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class FranchiseDTO {
	private Integer franchiseIdx;
	private Integer regionIdx; // 구역 고유번호
	private String franchiseName; // 지점명
	private String franchiseCode; // 지점코드
	private String franchiseAddress; // 주소
	private String franchisePhone; // 지점전화번호
	private String franchiseManagerName; // 담당자 이름
	private String bcode; // 법정동코드
	private String status; // 운영 , 휴점, 폐점으로 구분
	private Timestamp createdAt; // 생성일
	private Timestamp updatedAt; // 수정일
}
