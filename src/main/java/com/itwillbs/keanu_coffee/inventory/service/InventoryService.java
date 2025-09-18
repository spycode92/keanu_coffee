package com.itwillbs.keanu_coffee.inventory.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.common.dto.DisposalDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryUpdateDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseInfoDTO;
import com.itwillbs.keanu_coffee.inventory.mapper.InventoryMapper;

@Service
public class InventoryService {
	private final InventoryMapper inventoryMapper;
	
	

	public InventoryService(InventoryMapper inventoryMapper) {
		super();
		this.inventoryMapper = inventoryMapper;
	}



	public WarehouseInfoDTO getWarehouseInfo() {
		
		return inventoryMapper.selectWarehouseInfo();
	}



	public List<InventoryDTO> getInventoryItemsInEmployeesVirtualLocation(Integer empIdx) {
		
		return inventoryMapper.selectInventoryItemsInEmployeesVirtualLocation(empIdx);
		
	}


	// 재고 수량 업데이트
	@Transactional
	public void updateInventoryQuantity(InventoryUpdateDTO request, Integer empIdx) {
		inventoryMapper.updateInventoryQuantity(request);
		
		// 수량 감소 시 폐기 처리
		if (request.getIsDisposal()) {
			DisposalDTO disposal = new DisposalDTO();
			disposal.setEmpIdx(empIdx);
			disposal.setSection("INVENTORY");
			disposal.setReceiptProductIdx(request.getReceiptProductIdx());
			disposal.setDisposalAmount(request.getAdjustQuantity());
			disposal.setNote("실물 재고 수량과 다름");
			
			inventoryMapper.insertDisposal(disposal);
		}
	}


	@Transactional
	public void disposalInventoryQuantity(InventoryUpdateDTO request, DisposalDTO disposal, Integer empIdx) {
		//폐기수량
    	int disposalAmount = disposal.getDisposalAmount();
    	
//    	inventoryMapper.updateInventoryQuantity(request);
		
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
