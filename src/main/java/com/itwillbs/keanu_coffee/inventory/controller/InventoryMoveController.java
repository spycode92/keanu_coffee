package com.itwillbs.keanu_coffee.inventory.controller;




import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.service.InventoryMoveService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/inventory/move")
@RequiredArgsConstructor
public class InventoryMoveController {
	
	private final InventoryMoveService inventoryMoveService;
	
	//lotNumber로 상품사진조회
	@GetMapping("/getProductDetail/{lotNumber}")
	public ResponseEntity<Map<String,Object>> getProductDetail(@PathVariable String lotNumber){
		Map<String,Object> result = new HashMap<String, Object>();
		//상품의 유무 판별
		Boolean isExist = inventoryMoveService.selectProductByLotNumber(lotNumber);
		
		if(!isExist) {
			result.put("success", false);
			result.put("message", "해당 상품을 찾을 수 없습니다.");
			return ResponseEntity.ok(result); 
		}
		
		FileDTO file = inventoryMoveService.selectProductFileByLotNum(lotNumber);
		
		result.put("success", true);
		if(file != null) {
			result.put("fileIdx", file.getFileIdx());
	    }
		
		return ResponseEntity.ok(result);
	}
	
	
	//로케이션에 있는 상품 조회
	@GetMapping("/getInventoryLocation/{locationName}")
	public ResponseEntity<Map<String,Object>> getInventoryLocation(@PathVariable String locationName){
		
		Map<String,Object> result = new HashMap<String, Object>();
		//입력받은 로케이션의 유무 판별
		Boolean isExist = inventoryMoveService.selectLocationByLocationName(locationName);
		
		if(!isExist) {
			result.put("success", false);
			result.put("message", "해당 로케이션을 찾을 수 없습니다.");
			return ResponseEntity.ok(result); 
		}
		
		List<InventoryDTO> inventoryList = inventoryMoveService.selectInventoryListByLocationName(locationName);
				
		result.put("success", true);
		result.put("message", "제품 정보를 성공적으로 조회했습니다.");
		result.put("inventoryList", inventoryList);
		return ResponseEntity.ok(result);
	}
	

}
