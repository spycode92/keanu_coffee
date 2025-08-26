package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.ProductMapper;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductService {
	
	private final ProductMapper productMapper;
	private final EmployeeManagementMapper employeeManagementMapper;
	private final HttpSession session;
	private final FileMapper fileMapper;
	
	
	//등록된상품리스트
	public List<SupplierProductContractDTO> getProductsInfo() {
		return productMapper.selectProductsInfo();
	}
	
	
	// 카테고리 전체목록
	public List<SupplierProductContractDTO> getAllCategoriesAsMap() {
		return productMapper.selectAllCategoriesAsMap();
	}
	
	// 카테고리 추가
	public void addCategoryFromMap(SupplierProductContractDTO category) {
		productMapper.insertCategory(category);

	}
	
	//카테고리수정
	public void modifyCategory(SupplierProductContractDTO category) {
		productMapper.updateCategory(category);		
	}
	
	//카테고리삭제
	public boolean removeCategoryIfUnused(Integer idx) {
		//상품 테이블에 해당 카테고리 idx를 참조하는 상품이 있는지 검사
		int productCount = productMapper.countProductByCategoryIdx(idx);
		//자식카테고리가존재할때 
		int categoryCount = productMapper.countCategoryByCategoryIdx(idx);

		if(productCount == 0 && categoryCount == 0) {
			productMapper.deleteCategory(idx);
			return true;
		}
		
		return false;
	}
	
	//상품등록
	@Transactional
	public Boolean addProduct(SupplierProductContractDTO product) throws IOException {
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
	//상품전체
	public List<SupplierProductContractDTO> getProductList() {

		return productMapper.selectAllProductList();
	}
	
	//대분류 필터링
	public List<SupplierProductContractDTO> getProductsByCategoryIdxList(List<Long> categoryIdxList) {
		return productMapper.selectProductByCategoryIdxList(categoryIdxList);
	}
	
	//소분류필터링
	public List<SupplierProductContractDTO> getProductsByCategoryIdx(Long categoryIdx) {
		return productMapper.selectProductsByCategoryIdx(categoryIdx);
	}
	
	//상품상세정보
	public SupplierProductContractDTO getProductDetail(SupplierProductContractDTO product) {
		//상품등록시 추가한 이미지파일 검색
		FileDTO file = fileMapper.getFileWithTargetTable("product", product.getProductIdx());
		// 상품정보불러오기
		product = productMapper.selectProductByProductIdx(product.getProductIdx());
		//파일고유번호 dto저장
		if (file != null) {
			product.setFileIdx(file.getIdx());
		}
		
		return product;
	}
	
	//상품정보수정
	@Transactional
	public Boolean modifyProduct(SupplierProductContractDTO product) throws IOException {
		// 현재 product에 들어있는  파일 저장
		product.setIdx(product.getProductIdx());
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
					fileMapper.updateFiles(files, file.getIdx());
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
	

	
	
	

	
}
