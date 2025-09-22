package com.itwillbs.keanu_coffee.inventory.controller;




import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.inventory.dto.InventoryDTO;
import com.itwillbs.keanu_coffee.inventory.dto.WarehouseLocationDTO;
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
	
	@PostMapping("/addCart")
	@ResponseBody
	public ResponseEntity<Map<String,Object>> addCart(@RequestBody InventoryDTO inventory, Authentication authentication){
		Map<String,Object> result = new HashMap<String, Object>();
		try {
			//카트에 추가 
			inventoryMoveService.addCart(inventory, authentication);
	        result.put("message", "상품을 카트에 담았습니다.");
		} catch (IllegalArgumentException  e) {
			result.put("icon", "warning");
	        result.put("message", e.getMessage());
	        return ResponseEntity.badRequest().body(result);
		} catch (Exception e) {
	        // 기타 시스템 오류
			result.put("icon", "warning");
	        result.put("message", "시스템 오류가 발생했습니다.");
	        return ResponseEntity.internalServerError().body(result);
	    }
		
		return ResponseEntity.ok(result);
	}
	
	@GetMapping("/cart")
	public String cart(Authentication authentication, Model model) {
		
		String empNo = authentication.getName();
//		System.out.println(empNo);
		List<Map<String,Object>> inventoryList = inventoryMoveService.getInventoryInfo(empNo);
		model.addAttribute("inventoryList", inventoryList);
		return "/inventory/move_inventory_cart";
	}
	
	//locationName로 위치조회
//	@GetMapping("/getLocationList")
//	public ResponseEntity<List<WarehouseLocationDTO>> getLocationList(){
//		System.out.println("dddddddddddddddddd");
//		//전체 로케이션 정보 받아오기
//		List<WarehouseLocationDTO> locationList = inventoryMoveService.getAllLocationInfo(); 
//		
//		return ResponseEntity.ok(locationList);
//	}
	
	//로케이션이름으로 로케이션 존재확인
	@GetMapping("/isLocationExist/{locationName}")
	public ResponseEntity<Map<String,Object>> isLocationExist(@PathVariable String locationName){
		Map<String,Object> result = new HashMap<String, Object>();
//		System.out.println(locationName);
		//상품의 유무 판별
		Boolean isExist = inventoryMoveService.getLocationCount(locationName);
		
		if(!isExist) {
			return ResponseEntity.status(404).body(result); 
		}
		
		return ResponseEntity.ok(result);
	}
	
	@PostMapping("/moveLocation")
	@ResponseBody
	public ResponseEntity<Map<String,Object>> moveLocation(@RequestBody InventoryDTO inventory, Authentication authentication){
		Map<String,Object> result = new HashMap<String, Object>();
		try {
			//카트에서 로케이션으로 진열
			inventoryMoveService.moveInventory(inventory, authentication);
	        result.put("message", "상품진열을 완료하였습니다.");
		} catch (IllegalArgumentException  e) {
			result.put("icon", "warning");
	        result.put("message", e.getMessage());
	        return ResponseEntity.badRequest().body(result);
		} catch (Exception e) {
	        // 기타 시스템 오류
			result.put("icon", "warning");
	        result.put("message", "시스템 오류가 발생했습니다.");
	        return ResponseEntity.internalServerError().body(result);
	    }
		
		return ResponseEntity.ok(result);
	}
	
	

}
