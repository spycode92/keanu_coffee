package com.itwillbs.keanu_coffee.demoData.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplyContractDTO;

@Mapper
public interface DemoDataMapper {

	List<EmployeeInfoDTO> getEmployeeData();

	List<EmployeeInfoDTO> getEmployeeDataByRole(int roleIdx);

	List<SupplyContractDTO> getSupplyContract();
	
	
}
