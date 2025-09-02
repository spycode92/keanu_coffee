package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface InventorySearchMapper {
	
	// 총 데이터 개수
    int selectInventoryCount(
            @Param("keyword") String keyword,
            @Param("location") String location,
            @Param("locationType") String locationType,
            @Param("mfgDate") String mfgDate,
            @Param("expDate") String expDate,
            @Param("stockStatus") String stockStatus,
            @Param("outboundStatus") String outboundStatus
    );
	
    // 리스트 조회
    List<Map<String, Object>> selectReceiptProductList(
            @Param("startRow") int startRow,
            @Param("listLimit") int listLimit,
            @Param("keyword") String keyword,
            @Param("location") String location,
            @Param("locationType") String locationType,
            @Param("mfgDate") String mfgDate,
            @Param("expDate") String expDate,
            @Param("stockStatus") String stockStatus,
            @Param("outboundStatus") String outboundStatus,
            @Param("sortOption") String sortOption,
            @Param("qtySort") String qtySort,
            @Param("fifo") String fifo
    );
	
	
}
