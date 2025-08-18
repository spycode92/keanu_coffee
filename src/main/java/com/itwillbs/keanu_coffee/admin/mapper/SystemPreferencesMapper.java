package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;

@Mapper
public interface SystemPreferencesMapper {
	//부서목록 받아오기
	List<DepartTeamRoleDTO> getDepartmentInfo();
	
	//해당부서 팀목록 받아오기
	List<DepartTeamRoleDTO> getTeamsInfoByDepartmentIdx(int departmentIdx);
	
	//해당부서의 직책목록 받아오기
	List<DepartTeamRoleDTO> getRolesInfoByDepartmentIdx(int departmentIdx);
	
	// 부서추가
	void insertDepartment(DepartTeamRoleDTO departTeamRoleDTO);
	
	// 팀추가
	void insertTeam(DepartTeamRoleDTO departTeamRoleDTO);
	
	// 직책추가
	void insertRole(DepartTeamRoleDTO departTeamRoleDTO);
	
	// 직책삭제
	int deleteRole(Long roleIdx);
	
	// 직책,메뉴,권한 테이블이 가지고있는 직책 삭제
	void deleteRoleMenuAuthoByRoleIdx(Long roleIdx);
	
	// 팀 삭제
	int deleteTeam(Long teamIdx);
	
	//부서에 속한 팀목록
	List<DepartTeamRoleDTO> departTeamList(Long departmentIdx);
	
	//부서에 속한 직책목록
	List<DepartTeamRoleDTO> departRoleList(Long departmentIdx);
	
	//부서삭제
	int deleteDepartment(Long departmentIdx);
	//부서이름 변경
	int updateDepartment(@Param("idx") int idx, @Param("departmentName") String departmentName);
	//팀이름 변경
	int updateTeam(@Param("idx")int idx, @Param("teamName")String teamName);
	//직책이름 변경
	int updateRole(@Param("idx")int idx, @Param("roleName")String roleName);
	
	//공급업체 리스트
	List<SupplierProductContractDTO> selectSuppliersInfo();
	//등록된상품리스트
	List<SupplierProductContractDTO> selectProductsInfo();
	//공급업체계약리스트
	List<SupplierProductContractDTO> selectSupplyContractsInfo();
	// 공급업체등록
	void insertSupplier(SupplierProductContractDTO supplierDTO);
	//공급업체 필터링
	List<SupplierProductContractDTO> selectSupplierByStatus(String dbStatus);
	//공급업체 삭제시 계약이남아있나 확인
	int countActiveContractsBySupplier(Long supplierIdx);
	// 공급업체 삭제
	int deleteSupplierByIdx(Long supplierIdx);
	//공급업체상세정보
	SupplierProductContractDTO selectSupplierInfo(Long idx);
	// 공급업체 정보 수정
	int updateSupplier(SupplierProductContractDTO supplier);
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
