package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmployeeManagementService {
	
	private final EmployeeManagementMapper employeeManagementMapper;
	private final BCryptPasswordEncoder passwordEncoder;
	private final FileMapper fileMapper;
	
	@Autowired
	private HttpSession session;
	
	//직원목록선택
	public List<EmployeeInfoDTO> getEmployeeList(
			int startRow, int listLimit, String searchType, String searchKeyword, String orderKey, String orderMethod) {
		
		
		return employeeManagementMapper.selectEmployeeList(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod);
	}
	
	
	
	
	//직원정보 DB입력로직
	@Transactional
	public int inputEmployeeInfo(EmployeeInfoDTO employee) throws IOException {
		// 첫 비밀번호 1234 
		String empPassword = passwordEncoder.encode("1234");
		// empId생성
		String empNo = empNoBuilder(employee);
		
		//empId, empPassword DTO 주입
		employee.setEmpNo(empNo);
		employee.setEmpId(empNo);
		employee.setEmpPassword(empPassword);
		
		List<FileDTO> fileList = FileUtils.uploadFile(employee, session);
		
		if(!fileList.isEmpty()) {
			fileMapper.insertFiles(fileList); // 새이미지저장
		}
		
		return employeeManagementMapper.insertEmployeeInfo(employee);
	}
	
	//직원아이디 사용해서 직원정보 선택
	public EmployeeInfoDTO getEmployeeInfo(EmployeeInfoDTO employee) {
		String empId = employee.getEmpId();
		return employeeManagementMapper.selectEmployeeInfo(empId);
	}
	
	
	
	
	
	// empId 생성 메서드
	public String empNoBuilder(EmployeeInfoDTO employee) {
		//입력된휴대폰번호
		String phone = employee.getEmpPhone();
		//휴대폰번호 뒷 4자리
		String last4Digits = phone.substring(phone.length() - 4);
		//오늘 날짜 MMdd 형식
		String today = new SimpleDateFormat("MMdd").format(new Date());
		
		// 랜덤 4자리 숫자
		Random rnd = new Random();
        int randomNum = rnd.nextInt(9000) + 1000; // 1000 ~ 9999
		
		return last4Digits + today + randomNum;
	}




	public int getEmployeeCount(String searchType, String searchKeyword) {
		
		return employeeManagementMapper.countEmployee(searchType, searchKeyword );
	}

	
	
}
