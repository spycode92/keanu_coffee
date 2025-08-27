package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierProductContractDTO;


public interface SupplyContractMapper {
	// 계약목록
	List<SupplierProductContractDTO> selectSupplyContractsInfo();
	//계약추가
	int insertContract(SupplierProductContractDTO supplyContract);
	//계약상세
	SupplierProductContractDTO selectContractDetail(SupplierProductContractDTO supplyContract);
	//계약수정
	int updateContractDetail(SupplierProductContractDTO contract);
	//계약삭제
	int deleteContractDetail(SupplierProductContractDTO contract);

	
}
