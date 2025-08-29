package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface InventorySearchMapper {
	
	// 재고 리스트(입고완료 데이터) 조회
	List<Map<String, Object>> selectReceiptProductList();
	

}
