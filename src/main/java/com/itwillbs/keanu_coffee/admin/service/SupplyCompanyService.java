package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.SupplyCompanyMapper;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SupplyCompanyService {
	
	private final SupplyCompanyMapper supplyCompanyMapper;
	private final EmployeeManagementMapper employeeManagementMapper;
	private final HttpSession session;
	private final FileMapper fileMapper;
	
	//등록된공급업체리스트
	public List<SupplierDTO> getSuppliersInfo(int startRow, int listLimit, String searchType, String searchKeyword, String orderKey, String orderMethod) {
		return supplyCompanyMapper.selectSuppliersInfo(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod);
	}

	// 공급업체목록 수
	public int getSupplierCount(String searchType, String searchKeyword) {
		return supplyCompanyMapper.getSupplierCount(searchType, searchKeyword);
	}
	
	//공급업체등록
	public SupplierDTO addSupplier(SupplierDTO supplierDTO) {
		supplyCompanyMapper.insertSupplier(supplierDTO);
		
		return supplierDTO;
	}
	
	//상태별 공급업체 필터링
	public List<SupplierDTO> getSuppliersByStatus(String status) {
		 String dbStatus = null;
        if ("ACTIVE".equals(status)) {
            dbStatus = "계약중";
        } else if ("EXPIRED".equals(status)) {
            dbStatus = "계약만료";
        }
        
		return supplyCompanyMapper.selectSupplierByStatus(dbStatus);
	}
	
	//공급업체삭제
	public boolean removeSupplierByIdx(Long supplierIdx) {
		int activeContractCount = supplyCompanyMapper.countActiveContractsBySupplier(supplierIdx);
		if (activeContractCount > 0) {
            // 계약이 남아있어서 삭제 불가
            return false;
        }
		// 실제 삭제 수행 (0이면 실패/예외처리)
        int deletedCnt = supplyCompanyMapper.deleteSupplierByIdx(supplierIdx);
        return deletedCnt > 0;
	}
	
	//공급업체 상세보기
	public SupplierDTO selectSupplierByIdx(Long idx) {

		return supplyCompanyMapper.selectSupplierInfo(idx);
	}
	//공급업체 정보변경
	public int modifySupplier(SupplierDTO supplier) {
		return supplyCompanyMapper.updateSupplier(supplier);
	}
	
	

	
}
