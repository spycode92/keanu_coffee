package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.mysql.cj.Session;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LoginService {
	private final EmployeeManagementMapper employeeManagementMapper;
	private final BCryptPasswordEncoder passwordEncoder;
	@Autowired
	HttpSession session;
	
	public boolean checkPassword(EmployeeInfoDTO employee) {
		
		// 입력받은 id, 비밀번호
		String empNo = employee.getEmpNo();
		String inputPw = employee.getEmpPassword();
		
		// 입력받은 id로 조회한 정보
		employee = employeeManagementMapper.selectEmployeeInfoByEmpNo(empNo);
		
		//조회된 정보가 있을때
		if(employee != null ) {
			// 재직중일때
			if(employee.getEmpStatus().equals("재직")){

				// 비밀번호가 일치할 때
				if(passwordEncoder.matches(inputPw, employee.getEmpPassword())) {
					session.setAttribute("empIdx", employee.getEmpIdx()); // 사원고유번호 저장
					session.setAttribute("empNo", employee.getEmpNo()); // 사번정보저장
					session.setAttribute("empName", employee.getEmpName()); // 사원이름 저장
					return true;
				}
				
			} 
		} 
				
		return false;
	}

}
