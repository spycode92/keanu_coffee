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
	public void updateInventoryQuantity(InventoryUpdateDTO request) {
		inventoryMapper.updateInventoryQuantity(request);
	}


	@Transactional
	public void disposalInventoryQuantity(InventoryUpdateDTO request, DisposalDTO disposal, Integer empIdx) {
		//폐기수량
    	int disposalAmount = disposal.getDisposalAmount();
    	int currentQuantity = request.getQuantity();
    	int remainQuantity = currentQuantity - disposalAmount;
    	
    	//폐기수량을뺀 후 폐기
    	request.setQuantity(remainQuantity);
    	inventoryMapper.updateInventoryQuantity(request);
    	
    	disposal.setEmpIdx(empIdx);
		disposal.setSection("INVENTORY");
		
    	inventoryMapper.insertDisposal(disposal);
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
