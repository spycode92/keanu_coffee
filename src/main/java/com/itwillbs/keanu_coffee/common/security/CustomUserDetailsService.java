package com.itwillbs.keanu_coffee.common.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
@Service
@RequiredArgsConstructor
@Log4j2
public class CustomUserDetailsService implements UserDetailsService{
	private final EmployeeManagementMapper employeeManagementMapper;

	@Override
	public UserDetails loadUserByUsername(String empNo) throws UsernameNotFoundException {
		
		EmployeeDetail employeeDetail = employeeManagementMapper.selectEmployeeDetailByEmpNo(empNo)
				.orElseThrow(() -> new UsernameNotFoundException("존재하지 않는 사용자입니다 - " + empNo));
		
		return employeeDetail;
	}
	
}
