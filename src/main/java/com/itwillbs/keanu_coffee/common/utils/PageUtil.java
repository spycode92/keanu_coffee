package com.itwillbs.keanu_coffee.common.utils;

import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;

public class PageUtil {
	// listLimit, listCount, pageNum, pageListLimit을 받아서 pageInfoDTO 생성 후 리턴
		// listLimit : 한 페이지 당 표시할 목록 갯수
		// listCount : 조회할 전체 게시물의 수
		// pageNum : 페이지번호
		// pageListLimit : 페이지당 페이지번호 갯수 설정 ex) 3으로 설정시(1 2 3 or 4 5 6)
		public static PageInfoDTO paging(int listLimit, int listCount, int pageNum, int pageListLimit ) {
			int startRow = (pageNum - 1) * listLimit;
			int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
			
			if(maxPage == 0) {
				maxPage = 1;
			}
				
			int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
			
			int endPage = startPage + pageListLimit - 1;
			
			if(endPage > maxPage) {
				endPage = maxPage;
			}
		
			PageInfoDTO pageInfoDTO = new PageInfoDTO(listCount, pageListLimit, maxPage, startPage, endPage, pageNum, startRow);
			return pageInfoDTO;
		}
}
