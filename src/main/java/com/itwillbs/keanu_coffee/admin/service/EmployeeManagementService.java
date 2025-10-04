package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.OrganizationMapper;
import com.itwillbs.keanu_coffee.common.aop.annotation.SystemLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.SystemLogTarget;
import com.itwillbs.keanu_coffee.common.security.EmployeeDetail;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmployeeManagementService {
	
	private final EmployeeManagementMapper employeeManagementMapper;
	private final OrganizationMapper organizationMapper;
	private final BCryptPasswordEncoder passwordEncoder;
	
	
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

	// 직원추가모달 부서,팀,직무 정보 불러오기
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
		
		employeeManagementMapper.InsertEmployeeInventory(employee);
		
		return inputCount;
	}
	
	
	// empNo 생성 메서드
	public String empNoBuilder(EmployeeInfoDTO employee) {
		//오늘 날짜 MMdd 형식
		String today = new SimpleDateFormat("yyMMdd").format(new Date());
		
		String maxEmpNo = employeeManagementMapper.selectEmpNo(today);
		int nextSeq = 1;
		if (maxEmpNo != null && maxEmpNo.length() == 10) {
		    String seqStr = maxEmpNo.substring(6);
		    nextSeq = Integer.parseInt(seqStr) + 1;
		} else {
		    nextSeq = 1; // 신규 생성 첫 번호
		}
		
		return today + String.format("%04d", nextSeq);
	}
	
	//회원idx를 이용해서 회원정보 불러오기
	@Transactional(readOnly = true)
	public EmployeeInfoDTO getOneEmployeeInfoByEmpIdx(Integer empIdx) {
		return employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(empIdx);
	}
	
	// 회원정보 업데이트 
	@Transactional
	@SystemLog(target = SystemLogTarget.EMPLOYEE_INFO)
	public int modifyEmployeeInfo(EmployeeInfoDTO employee) throws IllegalStateException, IOException {
		
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
	
	//직무별 직원정보 구하기
	public List<EmployeeInfoDTO> selectEmpInfoByRole(String roleName){
		List<EmployeeInfoDTO> employeeList = employeeManagementMapper.selectEmpInfoByRole(roleName);
		
		return employeeList;
	}





	
	
}
