package com.itwillbs.keanu_coffee.common.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageInfoDTO {
	private int listCount; // 총 게시물 수
	private int pageListLimit; // 페이지 당 표시할 페이지번호 갯수
	private int maxPage; // 전체 페이지 수(= 최대 페이지 번호)
	private int startPage; // 현재 페이지에서의 페이지 목록 시작 번호
	private int endPage; // 현재 페이지에서의 페이지 목록 끝 번호
	private int pageNum; // 현재 페이지 번호
	private int startRow;
}
