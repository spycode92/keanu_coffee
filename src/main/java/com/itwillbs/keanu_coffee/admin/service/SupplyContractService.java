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
	public List<SupplierDTO> getsupplyContractInfo() {
		return supplyContractMapper.selectSupplyContractsInfo();
	}
	
	//계약등록
	public boolean addContract(SupplierDTO supplyContract) {
		int insertCount = supplyContractMapper.insertContract(supplyContract);
		return insertCount > 0;
	}
	//계약상세
	public SupplierDTO getContractDetail(SupplierDTO supplyContract) {
		
		return supplyContractMapper.selectContractDetail(supplyContract);
	}
	//계약수정
	public SupplierDTO updateContractDetail(SupplierDTO contract) {
		int updateCount = supplyContractMapper.updateContractDetail(contract);
		
		return contract;
	}
	//계약삭제
	public boolean deleteContractDetail(SupplierDTO contract) {
		int updateCount = supplyContractMapper.deleteContractDetail(contract);
		return updateCount > 0;
	}

	
	
	

	
}
