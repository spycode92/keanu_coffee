package com.itwillbs.keanu_coffee.inventory.service;

import java.security.Principal;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;
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
		int selectCount = inventoryMoveMapper.selectCountLocationByLocationName(locationName);
		return selectCount > 0;
	}

	// 로케이션이름으로 인벤토리 정보 가져오기
	public List<InventoryDTO> selectInventoryListByLocationName(String locationName) {

		return inventoryMoveMapper.selectInventoryListByLocationName(locationName);
	}
	
	//카트에 추가
	@Transactional
	public void addCart(InventoryDTO inventory, Authentication authentication) {
		//사번
		String empNo = authentication.getName();
		//이동할 수량
		int moveQuantity = inventory.getQuantity();
		
		//카트정보 조회해오기
		WarehouseLocationDTO location = inventoryMoveMapper.selectLocationByLocationName(empNo);
		//받은 로케이션이름과 로트번호로 해당위치 재고정보조회해오기
		inventory = inventoryMoveMapper.selectInventoryByLocationNAmeAndLotNumber(inventory);
		System.out.println("11111111111111111111111111");
		System.out.println(inventory);
		// 해당위치 재고수량
		int OriginalInventoryQuantity = inventory.getQuantity();
		int OriginalInventoryIdx = inventory.getInventoryIdx();
		// insert데이터 만들기
		inventory.setLocationIdx(location.getLocationIdx());
		inventory.setLocationName(location.getLocationName());
		inventory.setQuantity(moveQuantity);
		
		//내 카트에 해당물건이 이미 들어있는지 체크
		int sameReceiptIdxCount = inventoryMoveMapper.selectCountSameReceiptIdxAtLocation(inventory);
		
		if(sameReceiptIdxCount > 0) {
			// 내카트에 해당 물건이 있다면 수량갱신
			inventoryMoveMapper.updateInventory(inventory);
		} else {//내 카트에 해당 물건이 없다면
			//이동할 물량만큼 인벤토리테이블에 생성
			inventoryMoveMapper.insertInventory(inventory);
		}

		//재고의 수량이 이동할 물건보다 많을때(남기고가져갈때)
		if(OriginalInventoryQuantity > moveQuantity) {

			int remainQuantity = OriginalInventoryQuantity - moveQuantity;
			//이동한 물량만큼 재고 차감
			inventoryMoveMapper.updateInventoryQuantity(remainQuantity, OriginalInventoryIdx);

		} else if(OriginalInventoryQuantity == moveQuantity) { 
			//해당위치의 해당물건 데이터 삭제
			System.out.println("ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");
			inventoryMoveMapper.deleteInventoryDataByInventoryIdx(OriginalInventoryIdx);
		} else {
			throw new IllegalArgumentException(
		            String.format("이동 가능한 수량을 다시 확인하십시오. 현재재고(%d)", OriginalInventoryQuantity));
		}
		
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
