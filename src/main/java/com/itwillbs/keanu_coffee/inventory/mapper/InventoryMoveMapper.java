package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;

@Mapper
public interface InventoryMoveMapper {
	
	//상품의 존재 체크
	int selectProductByLotNumber(String lotNumber);
	
	// lotNum으로 상품이미지가져오기
	FileDTO selectProductFileByLotNum(String lotNum);
	
	//로케이션 존재 체크
	int selectCountLocationByLocationName(String locationName);
	
	//해당 로케이션의 재고리스트가져오기
	List<InventoryDTO> selectInventoryListByLocationName(String locationName);
	
	//로케이션이름과 lot번호로 재고 정보 가져오기
	InventoryDTO selectInventoryByLocationNAmeAndLotNumber(InventoryDTO inventory);
	
	//로케이션이름으로 로케이션정보조회
	WarehouseLocationDTO selectLocationByLocationName(String locationName);
	
	//재고 입력
	void insertInventory(InventoryDTO inventory);
	//재고수량 업데이트
	void updateInventoryQuantity(@Param("quantity")int quantity, @Param("inventoryIdx")int inventoryIdx);
	//재고데이터삭제
	void deleteInventoryDataByInventoryIdx(int inventoryIdx);
	// 직원 카트에 해당물건이 있는지 확인
	int selectCountSameReceiptIdxAtLocation(InventoryDTO inventory);
	// 직원카트의 정보 업데이트
	void updateInventory(InventoryDTO inventory);
	// 카트에 담긴 재고 정보 조회
	List<Map<String, Object>> selectDetailInventoryListByLocationName(String locationName);
	//전체로케이션 정보 조회
	List<WarehouseLocationDTO> selectAllLocationInfo();



}
