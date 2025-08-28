package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;


public interface SupplyContractMapper {
	// 계약목록
	List<SupplierDTO> selectSupplyContractsInfo();
	//계약추가
	int insertContract(SupplierDTO supplyContract);
	//계약상세
	SupplierDTO selectContractDetail(SupplierDTO supplyContract);
	//계약수정
	int updateContractDetail(SupplierDTO contract);
	//계약삭제
	int deleteContractDetail(SupplierDTO contract);

	
}
