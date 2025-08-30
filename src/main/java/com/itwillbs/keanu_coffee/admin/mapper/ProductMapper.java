package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.ProductDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

@Mapper
public interface ProductMapper {
	//상품목록
	List<ProductDTO> selectAllProductList(@Param("startRow") int startRow, @Param("listLimit") int listLimit, 
			@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword,
			@Param("orderKey")String orderKey, @Param("orderMethod")String orderMethod, @Param("filterCategoryIdx")String filterCategoryIdx);
	//상품목록 수
	int countProductList(@Param("searchType")String searchType, @Param("searchKeyword")String searchKeyword, @Param("filterCategoryIdx")String filterCategoryIdx);
	//카테고리목록
	List<ProductDTO> selectAllCategoriesAsMap();
	//카테고리추가
	void insertCategory(String categoryName);
	// 카테고리수정
	void updateCategory(CommonCodeDTO category);
	//카테고리에 제품이있나 확인
	int countProductByCategoryIdx(Integer commonCodeIdx);
	// 카테고리삭제
	void deleteCategory(Integer idx);
	//상품등록
	int insertProduct(ProductDTO product);
	//상품상세정보
	ProductDTO selectProductByProductIdx(Integer productIdx);
	// 상품정보 수정
	int updateProduct(ProductDTO product);
	// 상품상태 수정
	int updateProductStatus(@Param("productIdx") Integer productIdx, @Param("status")String status);
	// 상품리스트 선택
	List<ProductDTO> selectAllProduct();

	
}
