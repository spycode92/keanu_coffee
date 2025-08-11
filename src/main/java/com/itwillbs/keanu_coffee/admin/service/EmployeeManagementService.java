package com.itwillbs.keanu_coffee.admin.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmployeeManagementService {
	
	private final EmployeeManagementMapper employeeManagementMapper;
	private final BCryptPasswordEncoder passwordEncoder;

	//직원정보 DB입력로직
	public int inputEmployeeInfo(EmployeeDTO employee) {
		// 첫 비밀번호 1234 
		String empPassword = passwordEncoder.encode("1234");
		// empId생성
		String empId = empIdBuilder(employee);
		
		//empId, empPassword DTO 주입
		employee.setEmpId(empId);
		employee.setEmpPassword(empPassword);
		
		return employeeManagementMapper.insertEmployeeInfo(employee);
	}
	
	//직원아이디 사용해서 직원정보 선택
	public EmployeeDTO getEmployeeInfo(EmployeeDTO employee) {
		String empId = employee.getEmpId();
		return employeeManagementMapper.selectEmployeeInfo(empId);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// empId 생성 메서드
	public String empIdBuilder(EmployeeDTO employee) {
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
	
}
