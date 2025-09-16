package com.itwillbs.keanu_coffee.inventory.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;

@Mapper
public interface InventoryMoveMapper {
	//상품의 존재 체크
	int selectProductByLotNumber(String lotNumber);
	// lotNum으로 상품이미지가져오기
	FileDTO selectProductFileByLotNum(String lotNum);
	//로케이션 존재 체크
	int selectLocationByLocationName(String locationName);
	//해당 로케이션의 재고리스트가져오기
	List<InventoryDTO> selectInventoryListByLocationName(String locationName);



}
