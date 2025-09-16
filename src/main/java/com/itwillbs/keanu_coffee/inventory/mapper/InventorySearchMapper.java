package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

@Mapper
public interface InventorySearchMapper {
	
	// 총 SKU
	int selectTotalSku();
	
	// 총 재고수량
	int selectTotalQuantity();
	
	// 카테고리 목록 조회
    List<CommonCodeDTO> selectCategoryList(@Param("groupCode") String groupCode);
	
	// 총 데이터 개수 (카테고리 추가)
    int selectInventoryCount(
            @Param("keyword") String keyword,
            @Param("location") String location,
            @Param("locationType") String locationType,
            @Param("mfgDate") String mfgDate,
            @Param("expDate") String expDate,
            @Param("stockStatus") String stockStatus,
            @Param("outboundStatus") String outboundStatus,
            @Param("sortOption") String sortOption,
            @Param("qtySort") String qtySort,
            @Param("category") String category
    );
	
    // 리스트 조회 (카테고리 추가)
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
            @Param("category") String category
    );
    
    // ---------- 재고 상세 모달창 (Ajax) ----------
    // 재고 상세
    Map<String, Object> selectInventoryDetail(int receiptProductIdx);
    // 로케이션 분포
    List<Map<String, Object>> selectLocationDistribution(int receiptProductIdx);
    
	
}
