package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryMapper;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryMoveMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InventoryMoveService {
	private final InventoryMoveMapper inventoryMoveMapper;
	
	//존재하는 상품인지 체크
	public Boolean selectProductByLotNumber(String lotNumber) {
		int selectCount = inventoryMoveMapper.selectProductByLotNumber(lotNumber);
		return selectCount > 0;
	}
	//로트번호로 상품파일id가져오기
	public FileDTO selectProductFileByLotNum(String lotNumber) {
		
		return inventoryMoveMapper.selectProductFileByLotNum(lotNumber);
	}
	
	//로케이션이 존재하는지 체크
	public Boolean selectLocationByLocationName(String locationName) {
		int selectCount = inventoryMoveMapper.selectLocationByLocationName(locationName);
		return selectCount > 0;
	}

	// 로케이션이름으로 인벤토리 정보 가져오기
	public List<InventoryDTO> selectInventoryListByLocationName(String locationName) {

		return inventoryMoveMapper.selectInventoryListByLocationName(locationName);
	}





//	public List<InventoryDTO> getInventoryThatNeedsToMoveFromInbound() {
//		// TODO Auto-generated method stub
//		return inventoryMapper.selectInventoryThatNeedsToMoveFromInbound();
//	}
//
//
//
//	public List<InventoryDTO> getInventoryThatNeedsToMoveToOutbound() {
//		// TODO Auto-generated method stub
//		return inventoryMapper.selectInventoryThatNeedsToMoveToOutbound();
//	}

}
