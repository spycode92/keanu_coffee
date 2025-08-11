package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LoginService {
	private final EmployeeManagementMapper employeeManagementMapper;
	private final BCryptPasswordEncoder passwordEncoder;

	public boolean checkPassword(EmployeeDTO employee) {
		// 입력받은 id, 비밀번호
		String empId = employee.getEmpId();
		String inputPw = employee.getEmpPassword();
		
		// 입력받은 id로 조회한 정보
		employee = employeeManagementMapper.selectEmployeeInfo(empId);
		//조회된 정보가 없을때
		if(employee == null) {
			return false;
		}
		//조회된 정보가 있을때
		if(passwordEncoder.matches(inputPw, employee.getEmpPassword())){
			return true;
		}
				
		return false;
	}

}
