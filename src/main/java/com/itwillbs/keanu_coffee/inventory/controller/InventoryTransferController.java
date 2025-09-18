package com.itwillbs.keanu_coffee.inventory.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.service.InventoryTransferService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inventory/transfer")
public class InventoryTransferController {
	private final InventoryTransferService inventoryTransferService;
	
	// 파레트존 데이터 (JSON)
    @GetMapping("/pallet")
    @ResponseBody
    public List<InventoryDTO> getPalletZoneStock() {
        return inventoryTransferService.selectPalletZoneStock();
    }

    // 피킹존 데이터 (JSON)
    @GetMapping("/picking")
    @ResponseBody
    public Map<String, Object> getPickingZoneStock() {
        Map<String, Object> result = new HashMap<>();
        result.put("pickingList", inventoryTransferService.selectPickingZoneStock()); 
        result.put("targetMap", inventoryTransferService.getTargetStockCache()); 
        result.put("replenishmentList", inventoryTransferService.selectPickingZoneNeedsReplenishment()); // 추가
        return result;
    }
	
}
