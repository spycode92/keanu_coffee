package com.itwillbs.keanu_coffee.admin.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DuplicateKeyException;
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
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.service.EmployeeManagementService;
import com.itwillbs.keanu_coffee.admin.service.OrganizationService;
import com.itwillbs.keanu_coffee.admin.service.ProductService;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.PageInfoDTO;
import com.itwillbs.keanu_coffee.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/systemPreference/product")
public class ProductController {
	private final ProductService productService;
	
	@GetMapping("")
	public String systemPreference(Model model, @RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "") String orderKey,
			@RequestParam(defaultValue = "") String orderMethod,
			@RequestParam(defaultValue = "") String filterCategoryIdx) {
		model.addAttribute("pageNum",pageNum);
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchKeyword",searchKeyword);
		model.addAttribute("sortKey",orderKey);
		model.addAttribute("sortMethod",orderMethod);
		model.addAttribute("filterCategoryIdx",filterCategoryIdx);
		//한페이지보여줄수
		int listLimit = 10;
		// 조회된 목록수
		int supplierCount = productService.getProductCount(searchType, searchKeyword, filterCategoryIdx);
		// 조회된 목록이 1개이상일때
		if(supplierCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, supplierCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/customer/notice_list");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
		
		
			List<ProductDTO> productList = productService.getProductList(
					pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword, orderKey,orderMethod, filterCategoryIdx);
			model.addAttribute("productList",productList);
		}
		
		
		return "/admin/system_preference/product_management";
	}
	
	//카테고리목록조회
    @GetMapping("/categories")
    @ResponseBody
    public List<ProductDTO> getCategories() {
        // DB에서 카테고리 정보를 Map 리스트로 반환
    	List<ProductDTO> categoryList = productService.getAllCategoriesAsMap();
        return categoryList; 
    }
    
    //카테고리추가
    @PostMapping("/addCategory")
    @ResponseBody
    public ResponseEntity<Map<String,String>> addCategory(@RequestBody CommonCodeDTO category) {
    	Map<String, String> response = new HashMap<>();
    	try {
	    	productService.addCategoryFromMap(category);
	    	response.put("result", "success");
	        response.put("message", "카테고리가 추가되었습니다.");
	        return ResponseEntity.ok(response);
    	} catch (DuplicateKeyException e) {
            response.put("result", "fail");
            response.put("message", "중복된 카테고리입니다.");
            return ResponseEntity.status(409).body(response); 
    	} catch (Exception e) {
            response.put("result", "error");
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(500).body(response);
    	}
    }
    
    //카테고리 수정
    @PutMapping("/modifyCategory")
    @ResponseBody
    public ResponseEntity<Map<String,String>> modifyCategory(@RequestBody CommonCodeDTO category) {
    	System.out.println(category);
    	Map<String, String> response = new HashMap<>();
    	try {
    		productService.modifyCategory(category);
	    	response.put("result", "success");
	        response.put("message", "카테고리가 수정되었습니다.");
	        return ResponseEntity.ok(response);
    	} catch (DuplicateKeyException e) {
            response.put("result", "fail");
            response.put("message", "중복된 카테고리명입니다.");
            return ResponseEntity.status(409).body(response); 
    	} catch (Exception e) {
            response.put("result", "error");
            response.put("message", "서버 오류가 발생했습니다.");
            return ResponseEntity.status(500).body(response);
    	}
    }
    
    //카테고리 삭제
    @DeleteMapping("/removeCategory")
    @ResponseBody
    public ResponseEntity<?> removeCategory(@RequestBody CommonCodeDTO category) {
        Integer commonCodeIdx = category.getCommonCodeIdx();
        // 서비스에서: 이 카테고리를 참조하는 상품이 있는지 체크
        boolean removed = productService.removeCategoryIfUnused(commonCodeIdx);
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
    public ResponseEntity<String> addProduct(@ModelAttribute ProductDTO product) throws IOException {
    	Boolean result = productService.addProduct(product);
    	if(result) {
    		return ResponseEntity.ok().header("Content-Type", "text/plain; charset=UTF-8")
    				.body("상품이 등록되었습니다.");
    	}
    	
    	return ResponseEntity.ok().header("Content-Type", "text/plain; charset=UTF-8")
    			.body("상품등록에 실패하였습니다.");
    }

    
    //상품상세정보
    @GetMapping("/getProductDetail")
    @ResponseBody
    public ProductDTO getProductDetail(ProductDTO product) {
    	product = productService.getProductDetail(product);
    	
    	return product;
    }
	
    //상품수정
    @PostMapping("/modifyProduct")
    @ResponseBody
    public ResponseEntity<String> modifyProduct(@ModelAttribute ProductDTO product) throws IOException {
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
    
	

}
