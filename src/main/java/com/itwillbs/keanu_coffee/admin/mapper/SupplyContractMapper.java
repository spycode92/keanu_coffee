package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.beust.jcommander.Parameter;
import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplyContractDTO;


public interface SupplyContractMapper {
	// 계약목록
	List<SupplyContractDTO> selectSupplyContractsInfo(
			@Param("startRow") int startRow, @Param("listLimit") int listLimit, 
			@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword,
			@Param("orderKey")String orderKey, @Param("orderMethod")String orderMethod,
			@Param("filterStatus")String filterStatus);
	
	// 계약목록 수
	int countContractList(@Param("searchType")String searchType, @Param("searchKeyword")String searchKeyword, @Param("filterStatus")String filterStatus);
	
	//계약추가
	int insertContract(SupplyContractDTO supplyContract);
	
	//계약상세
	SupplyContractDTO selectContractDetail(SupplyContractDTO supplyContract);
	
	//계약수정
	int updateContractDetail(SupplyContractDTO contract);
	
	//계약삭제
	int deleteContractDetail(SupplyContractDTO contract);
	
	//상품idx로 계약갯수검색
	int selectContractWithproductIdx(Integer productIdx);
	// 공급처idx로 계약갯수검색
	int selectContractWithSupplierIdx(Integer supplierIdx);

	
}
