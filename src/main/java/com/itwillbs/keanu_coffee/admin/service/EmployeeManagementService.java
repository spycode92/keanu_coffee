package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.annotation.Around;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.OrganizationMapper;
import com.itwillbs.keanu_coffee.common.aop.annotation.Insert;
import com.itwillbs.keanu_coffee.common.aop.annotation.SystemLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.SystemLogTarget;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmployeeManagementService {
	
	private final EmployeeManagementMapper employeeManagementMapper;
	private final OrganizationMapper organizationMapper;
	private final BCryptPasswordEncoder passwordEncoder;
	private final FileMapper fileMapper;
	
	@Autowired
	private HttpSession session;
	
	//직원목록선택
	@Transactional(readOnly = true)
	public List<EmployeeInfoDTO> getEmployeeList(
			int startRow, int listLimit, String searchType, String searchKeyword, String orderKey, String orderMethod) {
		
		List<EmployeeInfoDTO> List = employeeManagementMapper.selectEmployeeList(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod);
		return List;
	}
	
	// 직원 목록 갯수
	@Transactional(readOnly = true)
	public int getEmployeeCount(String searchType, String searchKeyword) {
		return employeeManagementMapper.countEmployee(searchType, searchKeyword );
	}

	// 직원추가모달 부서,팀,직책 정보 불러오기
	@Transactional(readOnly = true)
	public List<Map<String, Object>> getOrgData() {
		return organizationMapper.getOrgData();
	}
	
	//직원추가 로직
	@Transactional
	@SystemLog(target = SystemLogTarget.EMPLOYEE_INFO)
	public int insertEmployeeInfo(EmployeeInfoDTO employee) throws IOException {
		// 첫 비밀번호 1234 
		String empPassword = passwordEncoder.encode("1234");
		// empId생성
		String empNo = empNoBuilder(employee);
		
		//empId, empPassword DTO 주입
		employee.setEmpNo(empNo);
		employee.setEmpPassword(empPassword);

		// 정보 입력 후 empIdx 받아오기
		int inputCount = employeeManagementMapper.insertEmployeeInfo(employee);
		
		return inputCount;
	}
	
	
	// empId 생성 메서드
	public String empNoBuilder(EmployeeInfoDTO employee) {
		//입력된휴대폰번호
		String phone = employee.getEmpPhone();
		//휴대폰번호 뒷 4자리
		String last4Digits = phone.substring(phone.length() - 4);
		//오늘 날짜 MMdd 형식
		String today = new SimpleDateFormat("MMdd").format(new Date());
		
		// 랜덤 2자리 숫자
		Random rnd = new Random();
        int randomNum = rnd.nextInt(90) + 10; // 10 ~ 99
		
		return last4Digits + today + randomNum;
	}
	
	//회원idx를 이용해서 회원정보 불러오기
	@Transactional(readOnly = true)
	public EmployeeInfoDTO getOneEmployeeInfoByEmpIdx(Integer empIdx) {
		return employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(empIdx);
	}
	
	// 회원정보 업데이트 
	@Transactional
	@SystemLog(target = SystemLogTarget.EMPLOYEE_INFO)
	public int modifyEmployeeInfo(EmployeeInfoDTO employee, Authentication authentication) throws IllegalStateException, IOException {
		EmployeeDetail empDetail = (EmployeeDetail)authentication.getPrincipal();
		Integer empIdx = empDetail.getEmpIdx();
		
		// 새로 받은 비밀번호가 존재한다면 암호화
		if(employee.getEmpPassword() != null && !employee.getEmpPassword().trim().isEmpty()) {
			String encodedPassword = passwordEncoder.encode(employee.getEmpPassword());
			employee.setEmpPassword(encodedPassword);
		}
		
		// 이메일 전화번호 비밀번호 저장
		int updateCount = employeeManagementMapper.updateEmployeeInfo(employee);
		
		return updateCount;
	}
	
	// 관리자가 직원정보 업데이트
	@SystemLog(target = SystemLogTarget.EMPLOYEE_INFO)
	public void updateEmployeeInfo(EmployeeInfoDTO employee) {
		employeeManagementMapper.updateEmployeeInfo(employee);
	}
	
	//직원 비밀번호 초기화(1234)
	@SystemLog(target = SystemLogTarget.EMPLOYEE_INFO)
	public int resetPw(EmployeeInfoDTO employee) {
		String empPassword = passwordEncoder.encode("1234");
		employee.setEmpPassword(empPassword);
		
		int updateCount = employeeManagementMapper.updateEmployeeInfo(employee);
		
		return updateCount;
	}






	
	
}
