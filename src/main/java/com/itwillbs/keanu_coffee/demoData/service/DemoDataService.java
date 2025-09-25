package com.itwillbs.keanu_coffee.demoData.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.SupplyContractDTO;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.demoData.mapper.DemoDataMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DemoDataService {

	private final DemoDataMapper demoDataMapper;
		
	public void makeData() {
		Integer InboundManagerIdx = 1; 
		List<EmployeeInfoDTO> employee = demoDataMapper.getEmployeeData();
		//직책별 직원정보
		List<EmployeeInfoDTO>inBoundManager = demoDataMapper.getEmployeeDataByRole(1);
		List<EmployeeInfoDTO>inBoundEmployee = demoDataMapper.getEmployeeDataByRole(2);
		List<EmployeeInfoDTO>outBoundManager = demoDataMapper.getEmployeeDataByRole(3);
		List<EmployeeInfoDTO>outBoundEmployee = demoDataMapper.getEmployeeDataByRole(4);
		List<EmployeeInfoDTO>InventoryManager = demoDataMapper.getEmployeeDataByRole(5);
		List<EmployeeInfoDTO>InventoryEmployee = demoDataMapper.getEmployeeDataByRole(6);
		List<EmployeeInfoDTO>TransportManager = demoDataMapper.getEmployeeDataByRole(7);
		List<EmployeeInfoDTO>TransportEmployee = demoDataMapper.getEmployeeDataByRole(8);
		
		//상품계약정보
		List<SupplyContractDTO> SupplyContract = demoDataMapper.getSupplyContract();
		
		System.out.println(SupplyContract);
		
		//발주 > 발주아이템 > 입고대기 목록
		Integer purchaseOrderIdx = 250925001;
		
		String orderName = "PO-"
			    + (purchaseOrderIdx / 1000)   // 앞 6자리: 250925
			    + "-" 
			    + String.format("%03d", purchaseOrderIdx % 1000);
		Integer supplierIdx = null;
		Integer empIdx = null;
		
		int datePart = purchaseOrderIdx / 1000;  // 250925
        
        // 앞 6자리 숫자를 문자열로 변환 (6자리 고정)
        String dateStr = String.format("%06d", datePart);
        String expectdateStr = String.format("06d", datePart + 3);
        
        // "yyMMdd" 형태를 LocalDate로 파싱
        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyMMdd");
        
        LocalDate date = LocalDate.parse(dateStr, inputFormatter);
        LocalDate expectDate = LocalDate.parse(expectdateStr, inputFormatter);
        // 원하는 출력 포맷 "yyyy-MM-dd 00:00:00"
        String orderDate = date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " 00:00:00";
        String expectedArrivalDate = date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " 00:00:00";
        String createdAt = orderDate;
        String updatedAt = orderDate;
        
		List<SupplyContractDTO> supplyContractList = demoDataMapper.getSupplyContract();

		if (supplyContractList != null && !supplyContractList.isEmpty()) {
		    Random random = new Random();
		    int randomIndex = random.nextInt(supplyContractList.size());
		    SupplyContractDTO randomContract = supplyContractList.get(randomIndex);
		    
		    supplierIdx = randomContract.getSupplierIdx();
		    
		}
		
		
		
		
		
		
		
	}

}
