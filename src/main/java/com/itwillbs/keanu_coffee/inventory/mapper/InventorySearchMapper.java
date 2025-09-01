package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface InventorySearchMapper {
	
	// 전체 데이터 개수
	int selectInventoryCount(@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword);
	
	// 페이징 데이터 조회
	List<Map<String, Object>> selectReceiptProductList(@Param("startRow") int startRow,
	        @Param("listLimit") int listLimit,
	        @Param("searchType") String searchType,
	        @Param("searchKeyword") String searchKeyword);
	
	

}
