package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.ProductMapper;
import com.itwillbs.keanu_coffee.admin.mapper.SupplyContractMapper;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductService {
	
	private final ProductMapper productMapper;
	private final EmployeeManagementMapper employeeManagementMapper;
	private final SupplyContractMapper supplyContractMapper;
	private final HttpSession session;
	private final FileMapper fileMapper;
	
	//상품전체목록
	public List<ProductDTO> getProductList(int startRow, int listLimit, String searchType, String searchKeyword, String orderKey, String orderMethod, String filterCategoryIdx) {
		return productMapper.selectAllProductList(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod, filterCategoryIdx);
	}
	
	//상품 리스트 갯수
	public int getProductCount(String searchType, String searchKeyword, String filterCategoryIdx) {
		return productMapper.countProductList(searchType, searchKeyword, filterCategoryIdx);
	}
	
	// 카테고리 전체목록
	public List<ProductDTO> getAllCategoriesAsMap() {
		return productMapper.selectAllCategoriesAsMap();
	}

	
	// 카테고리 추가
	public void addCategoryFromMap(CommonCodeDTO category) {
		
		productMapper.insertCategory(category.getCommonCodeName());

	}
	
	//카테고리수정
	public void modifyCategory(CommonCodeDTO category) {
		productMapper.updateCategory(category);		
	}
	
	//카테고리삭제
	public boolean removeCategoryIfUnused(Integer commonCodeIdx) {
		//상품 테이블에 해당 카테고리 idx를 참조하는 상품이 있는지 검사
		int productCount = productMapper.countProductByCategoryIdx(commonCodeIdx);

		if(productCount == 0) {
			productMapper.deleteCategory(commonCodeIdx);
			return true;
		}
		return false;
	}
	
	//상품등록
	@Transactional
	public Boolean addProduct(ProductDTO product) throws IOException {
		//상품DB등록
		int insertCount = productMapper.insertProduct(product);
		//상품파일업로드
		List<FileDTO> fileList = FileUtils.uploadFile(product, session);
		//상품파일DB등록
		if (!fileList.isEmpty()) {
	        fileMapper.insertFiles(fileList);
	    }
		return insertCount > 0;
	}
	
	//상품상세정보
	public ProductDTO getProductDetail(ProductDTO product) {
		// 상품정보불러오기
		product = productMapper.selectProductByProductIdx(product.getProductIdx());

		return product;
	}
	
	//상품정보수정
	@Transactional
	public Boolean modifyProduct(ProductDTO product) throws IOException {
		//상태를 삭제로 변경할때 
		if(product.getStatus().equals("삭제")){
			int productWithContract = supplyContractMapper.selectContractWithproductIdx(product.getProductIdx());
			if(productWithContract > 0 ) { return false;}
		}
		
		// 현재 product에 들어있는  파일 저장
		product.setProductIdx(product.getProductIdx());
		List<FileDTO> fileList = FileUtils.uploadFile(product, session);
		
		// 현재 product에 들어있는 product_idx를 이용해서 저장된 파일 정보 불러오기
		FileDTO file = fileMapper.getFileWithTargetTable("product", product.getProductIdx());
		
		// 새로 업로드한 파일이 있을 경우에만
	    if (!fileList.isEmpty()) {
	        if (file != null) {   // 기존 파일이 존재하면
	            // 기존 파일을 삭제하고
	            FileUtils.deleteFile(file, session);
	            // 새로 업로드한 파일로 DB 업데이트
				for(FileDTO files : fileList) {
					fileMapper.updateFiles(files, file.getFileIdx());
				}
	        } else { // 기존 파일이 없었으면 새 파일 정보 삽입
	            fileMapper.insertFiles(fileList);
	        }
	    }
	    
		int updateCount = productMapper.updateProduct(product);
		
		return updateCount > 0;
	}
	
	//상품상태 삭제변경
	public boolean changeProductStatus(Integer productIdx, String status) {
		int updateCount = productMapper.updateProductStatus(productIdx, status);
		return updateCount > 0;
	}
	
	// 상품 목록 가져오기
	public List<ProductDTO> getAllProductList() {
		return productMapper.selectAllProduct();
	}

	
	

	
	
	

	
}
