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
import com.itwillbs.keanu_coffee.admin.mapper.SystemPreferencesMapper;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SystemPreferencesService {
	
	private final SystemPreferencesMapper systemPreferencesMapper;
	private final EmployeeManagementMapper employeeManagementMapper;
	private final HttpSession session;
	private final FileMapper fileMapper;
	
	
	//부서 전체 목록 받아오기
	public List<DepartTeamRoleDTO> getDepartInfo() {
		return systemPreferencesMapper.getDepartmentInfo();
	}
	
	//해당 부서의 팀 목록 받아오기
	public List<DepartTeamRoleDTO> getTeamsByDepartmentIdx(int departmentIdx) {

		return systemPreferencesMapper.getTeamsInfoByDepartmentIdx(departmentIdx);
	}
	
	//해당 부서의 직책목록 받아오기
	public List<DepartTeamRoleDTO> getRolesByDepartmentIdx(int departmentIdx) {
		return systemPreferencesMapper.getRolesInfoByDepartmentIdx(departmentIdx);
	}
	
	//부서추가
	public DepartTeamRoleDTO addDepartment(DepartTeamRoleDTO departTeamRoleDTO) {
		systemPreferencesMapper.insertDepartment(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//팀 추가
	public DepartTeamRoleDTO addTeam(DepartTeamRoleDTO departTeamRoleDTO) {
		systemPreferencesMapper.insertTeam(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//직책추가
	public DepartTeamRoleDTO addRole(DepartTeamRoleDTO departTeamRoleDTO) {
		systemPreferencesMapper.insertRole(departTeamRoleDTO);
		return departTeamRoleDTO;
	}
	
	//부서삭제
	@Transactional
	public boolean removeDepartmentByIdx(Long departmentIdx) {
		// 해당 부서의 팀,직책 모두 NULL처리
		employeeManagementMapper.updateDeptTeamRoleToNull(departmentIdx);
		
		//해당 부서에 속해있는 팀목록, 팀수
		List<DepartTeamRoleDTO> departTeamDTOList 
			= systemPreferencesMapper.departTeamList(departmentIdx);
		
		for (DepartTeamRoleDTO dto : departTeamDTOList) {
			deleteTeamByIdx((long)dto.getIdx());
		}
		
		//해당 부서에 속해있는 직책 목록
		List<DepartTeamRoleDTO> departRoleDTOList 
			= systemPreferencesMapper.departRoleList(departmentIdx);
		
		for (DepartTeamRoleDTO dto : departRoleDTOList) {
			deleteRoleByIdx((long)dto.getIdx());
		}
		
		int deletedDept =systemPreferencesMapper.deleteDepartment(departmentIdx);
		
		return deletedDept == 1;
	}
	
	// 팀 삭제
	@Transactional
	public boolean deleteTeamByIdx(Long teamIdx) {
		// 직원정보 테이블의 팀 널로 바꾸기
		employeeManagementMapper.updateTeamToNull(teamIdx);
		
		//팀 삭제
		int deletedTeam = systemPreferencesMapper.deleteTeam(teamIdx);
	    return deletedTeam == 1;
	}
	
	// 직책삭제
	@Transactional
	public boolean deleteRoleByIdx(Long roleIdx) {
		// 중간테이블 게시판,권한,직책 테이블의 내용삭제
		systemPreferencesMapper.deleteRoleMenuAuthoByRoleIdx(roleIdx);
		
		// 직원정보 테이블의 roleIdx를 Null 값 또는 기본값 처리
		employeeManagementMapper.updateRoleToNull(roleIdx);
		
		// 직책삭제
		int affectedRows = systemPreferencesMapper.deleteRole(roleIdx);
		return affectedRows == 1;
	}
	
	//부서 이름수정
	public boolean modifyDepartmentName(int idx, String departmentName) {
		int affectedRows = systemPreferencesMapper.updateDepartment(idx, departmentName);
		
		return  affectedRows == 1;
	}

	//팀이름수정
	public boolean modifyTeamName(int idx, String teamName) {
		int affectedRows = systemPreferencesMapper.updateTeam(idx, teamName);
		
		return  affectedRows == 1;
	}
	// 직책이름 수정
	public boolean modifyRoleName(int idx, String roleName) {
		int affectedRows = systemPreferencesMapper.updateRole(idx, roleName);
		
		return  affectedRows == 1;
	}
	//등록된공급업체리스트
	public List<SupplierProductContractDTO> getSuppliersInfo() {
		return systemPreferencesMapper.selectSuppliersInfo();
	}
	
	//등록된상품리스트
	public List<SupplierProductContractDTO> getProductsInfo() {
		return systemPreferencesMapper.selectProductsInfo();
	}
	//공급계약리스트
	public List<SupplierProductContractDTO> getsupplyContractInfo() {
		return systemPreferencesMapper.selectSupplyContractsInfo();
	}
	//공급업체등록
	public SupplierProductContractDTO addSupplier(SupplierProductContractDTO supplierDTO) {
		systemPreferencesMapper.insertSupplier(supplierDTO);
		
		return supplierDTO;
	}
	
	//상태별 공급업체 필터링
	public List<SupplierProductContractDTO> getSuppliersByStatus(String status) {
		 String dbStatus = null;
        if ("ACTIVE".equals(status)) {
            dbStatus = "계약중";
        } else if ("EXPIRED".equals(status)) {
            dbStatus = "계약만료";
        }
        
		return systemPreferencesMapper.selectSupplierByStatus(dbStatus);
	}
	
	//공급업체삭제
	public boolean removeSupplierByIdx(Long supplierIdx) {
		int activeContractCount = systemPreferencesMapper.countActiveContractsBySupplier(supplierIdx);
		if (activeContractCount > 0) {
            // 계약이 남아있어서 삭제 불가
            return false;
        }
		// 실제 삭제 수행 (0이면 실패/예외처리)
        int deletedCnt = systemPreferencesMapper.deleteSupplierByIdx(supplierIdx);
        return deletedCnt > 0;
	}
	
	//공급업체 상세보기
	public SupplierProductContractDTO selectSupplierByIdx(Long idx) {

		return systemPreferencesMapper.selectSupplierInfo(idx);
	}
	//공급업체 정보변경
	public int modifySupplier(SupplierProductContractDTO supplier) {
		return systemPreferencesMapper.updateSupplier(supplier);
	}
	
	// 카테고리 전체목록
	public List<SupplierProductContractDTO> getAllCategoriesAsMap() {
		return systemPreferencesMapper.selectAllCategoriesAsMap();
	}
	
	// 카테고리 추가
	public void addCategoryFromMap(SupplierProductContractDTO category) {
		systemPreferencesMapper.insertCategory(category);

	}
	
	//카테고리수정
	public void modifyCategory(SupplierProductContractDTO category) {
		systemPreferencesMapper.updateCategory(category);		
	}
	
	//카테고리삭제
	public boolean removeCategoryIfUnused(Integer idx) {
		//상품 테이블에 해당 카테고리 idx를 참조하는 상품이 있는지 검사
		int productCount = systemPreferencesMapper.countProductByCategoryIdx(idx);
		//자식카테고리가존재할때 
		int categoryCount = systemPreferencesMapper.countCategoryByCategoryIdx(idx);

		if(productCount == 0 && categoryCount == 0) {
			systemPreferencesMapper.deleteCategory(idx);
			return true;
		}
		
		return false;
	}
	
	//상품등록
	@Transactional
	public Boolean addProduct(SupplierProductContractDTO product) throws IOException {
		//상품DB등록
		int insertCount = systemPreferencesMapper.insertProduct(product);
		//상품파일업로드
		List<FileDTO> fileList = FileUtils.uploadFile(product, session);
		//상품파일DB등록
		if (!fileList.isEmpty()) {
	        fileMapper.insertFiles(fileList);
	    }
		
		return insertCount > 0;
		
	}

	public List<SupplierProductContractDTO> getProductList() {

		return systemPreferencesMapper.selectAllProductList();
	}

	
	
	

	
}
