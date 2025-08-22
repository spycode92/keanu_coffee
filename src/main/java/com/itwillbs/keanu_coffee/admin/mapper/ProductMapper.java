package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;

@Mapper
public interface ProductMapper {
	//등록된상품리스트
	List<SupplierProductContractDTO> selectProductsInfo();
	//카테고리목록
	List<SupplierProductContractDTO> selectAllCategoriesAsMap();
	//카테고리추가
	void insertCategory(SupplierProductContractDTO category);
	// 카테고리수정
	void updateCategory(SupplierProductContractDTO category);
	//카테고리에 제품이있나 확인
	int countProductByCategoryIdx(Integer idx);
	//카테고리에 자식카테고리가있나확인
	int countCategoryByCategoryIdx(Integer idx);
	// 카테고리삭제
	void deleteCategory(Integer idx);
	//상품등록
	int insertProduct(SupplierProductContractDTO product);
	//상품목록
	List<SupplierProductContractDTO> selectAllProductList();
	//상품목록 - 필터대분류
	List<SupplierProductContractDTO> selectProductByCategoryIdxList(List<Long> categoryIdxList);
	// 상품목록 - 필터소분류
	List<SupplierProductContractDTO> selectProductsByCategoryIdx(Long categoryIdx);
	//상품상세정보
	SupplierProductContractDTO selectProductByProductIdx(Integer productIdx);

	int updateProduct(SupplierProductContractDTO product);

	int updateProductStatus(@Param("productIdx") Integer productIdx, @Param("status")String status);

	
}
