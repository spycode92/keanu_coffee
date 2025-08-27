package com.itwillbs.keanu_coffee.admin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.OrganizationService;
import com.itwillbs.keanu_coffee.admin.service.ProductService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/product")
public class ProductController {
	private final ProductService productService;
		
	//카테고리목록조회
    @GetMapping("/categories")
    @ResponseBody
    public List<SupplierDTO> getCategories() {
        // DB에서 카테고리 정보를 Map 리스트로 반환
    	List<SupplierDTO> categoryList = productService.getAllCategoriesAsMap();
        return categoryList; 
    }
    
    //카테고리추가
    @PostMapping("/addCategory")
    @ResponseBody
    public void addCategory(@RequestBody SupplierDTO category) {
    	productService.addCategoryFromMap(category);
    }
    
    //카테고리 수정
    @PutMapping("/modifyCategory")
    @ResponseBody
    public void modifyCategory(@RequestBody SupplierDTO category) {
    	productService.modifyCategory(category);
    }
    
    //카테고리 삭제
    @DeleteMapping("/removeCategory")
    @ResponseBody
    public ResponseEntity<?> removeCategory(@RequestBody SupplierDTO category) {
        Integer idx = category.getIdx();
        // 서비스에서: 이 카테고리를 참조하는 상품이 있는지 체크
        boolean removed = productService.removeCategoryIfUnused(idx);
        if(removed) {
            return ResponseEntity.ok().contentType(MediaType.valueOf("text/plain; charset=UTF-8"))
            		.body("카테고리가 삭제되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.CONFLICT)
            		.contentType(MediaType.valueOf("text/plain; charset=UTF-8"))
                    	.body("상품이 연결된 카테고리는 삭제할 수 없습니다. 확인후 다시시도 하십시오.");
        }
    }
	
	//상품등록
    @PostMapping("/addProduct")
    @ResponseBody
    public ResponseEntity<String> addProduct(@ModelAttribute SupplierDTO product) throws IOException {
    	Boolean result = productService.addProduct(product);
    	if(result) {
    		return ResponseEntity.ok().header("Content-Type", "text/plain; charset=UTF-8")
    				.body("상품이 등록되었습니다.");
    	}
    	
    	return ResponseEntity.ok().header("Content-Type", "text/plain; charset=UTF-8")
    			.body("상품등록에 실패하였습니다.");
    }
    //상품목록,필터링
    @GetMapping("/getProductList")
    @ResponseBody
    public List<SupplierDTO> getProductList(
    	    @RequestParam(value = "categoryIdx", required = false) Long categoryIdx,
    	    @RequestParam(value = "categoryIdxList", required = false) List<Long> categoryIdxList
    	) {
    	
    	// 1. 소분류 여러 개(배열)로 필터(*
        if (categoryIdxList != null && !categoryIdxList.isEmpty()) {
            return productService.getProductsByCategoryIdxList(categoryIdxList);
        }
        // 2. 단일 소분류로 필터
        else if (categoryIdx != null) {
            return productService.getProductsByCategoryIdx(categoryIdx);
        }
        // 4. 전체 목록
        else {
            return productService.getProductList();
        }
    }
    //상품상세정보
    @GetMapping("/getProductDetail")
    @ResponseBody
    public SupplierDTO getProductDetail(SupplierDTO product) {
    	product = productService.getProductDetail(product);
    	
    	return product;
    }
	
    //상품수정
    @PostMapping("/modifyProduct")
    @ResponseBody
    public ResponseEntity<String> modifyProduct(@ModelAttribute SupplierDTO product) throws IOException {
    	System.out.println(product);
    	Boolean result = productService.modifyProduct(product);
    	if(result) {
    		return ResponseEntity.ok("상품정보가 수정되었습니다.");
    	}
    	
    	return ResponseEntity.ok("상품정보 수정에 실패하였습니다.");
    }
	
    //상품삭제
    @DeleteMapping("/removeProduct")
    public ResponseEntity<String> removeProduct(@RequestBody Map<String, Object> request) {
    	
    	Object idxObj = request.get("productIdx");
        
    	Integer productIdx = null;
        
    	if (idxObj != null) {
            productIdx = Integer.valueOf(idxObj.toString());
        }
    	
        if (productIdx == null) {
            return ResponseEntity.badRequest().body("상품 번호가 올바르지 않습니다.");
        }
        
        String status = "삭제";
        boolean result = productService.changeProductStatus(productIdx, status);
        
        if (result) {
            return ResponseEntity.ok("상품이 삭제(비활성화) 처리되었습니다.");
        } else {
            return ResponseEntity.status(500).body("상품 삭제 처리에 실패했습니다.");
        }
    }
    
	
	@GetMapping("")
	public String systemPreference(Model model) {
		
		return "/admin/system_preference/product_management";
	}
}
