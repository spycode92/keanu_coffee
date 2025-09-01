package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.DepartmentDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplierDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplyContractDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.SupplyContractMapper;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SupplyContractService {
	
	private final SupplyContractMapper supplyContractMapper;
	private final HttpSession session;
	private final FileMapper fileMapper;
	
	//공급계약리스트
	@Transactional(readOnly = true)
	public List<SupplyContractDTO> getsupplyContractInfo(
			int startRow, int listLimit, String searchType, String searchKeyword, String orderKey, String orderMethod, String filterStatus) {
		return supplyContractMapper.selectSupplyContractsInfo(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod, filterStatus);
	}
	
	// 계약목록 수
	@Transactional(readOnly = true)
	public int getContractListCount(String searchType, String searchKeyword, String filterStatus) {
		return supplyContractMapper.countContractList(searchType, searchKeyword, filterStatus);
	}
	
	//계약등록
	public boolean addContract(SupplyContractDTO supplyContract) {
		int insertCount = supplyContractMapper.insertContract(supplyContract);
		return insertCount > 0;
	}
	
	//계약상세
	@Transactional(readOnly = true)
	public SupplyContractDTO getContractDetail(SupplyContractDTO supplyContract) {
		
		return supplyContractMapper.selectContractDetail(supplyContract);
	}
	
	//계약수정
	public SupplyContractDTO updateContractDetail(SupplyContractDTO contract) {
		int updateCount = supplyContractMapper.updateContractDetail(contract);
		
		return contract;
	}
	//계약삭제
	public boolean deleteContractDetail(SupplyContractDTO contract) {
		int updateCount = supplyContractMapper.deleteContractDetail(contract);
		return updateCount > 0;
	}


	
	
	

	
}
