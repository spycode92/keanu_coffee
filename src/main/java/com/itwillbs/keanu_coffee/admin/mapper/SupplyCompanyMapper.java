package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartTeamRoleDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;

@Mapper
public interface SupplyCompanyMapper {
	//공급업체 리스트
	List<SupplierProductContractDTO> selectSuppliersInfo();
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
}
