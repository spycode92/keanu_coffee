package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.mapper.EmployeeManagementMapper;
import com.itwillbs.keanu_coffee.admin.mapper.OrganizationMapper;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
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
	public List<EmployeeInfoDTO> getEmployeeList(
			int startRow, int listLimit, String searchType, String searchKeyword, String orderKey, String orderMethod) {
		return employeeManagementMapper.selectEmployeeList(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod);
	}
	
	// 직원 목록 갯수
	public int getEmployeeCount(String searchType, String searchKeyword) {
		return employeeManagementMapper.countEmployee(searchType, searchKeyword );
	}

	// 직원추가시 부서,팀,직책 정보 불러오기
	public List<Map<String, Object>> getOrgData() {
		return organizationMapper.getOrgData();
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
		// 정보 입력 후 empIdx 받아오기
		int inputCount = employeeManagementMapper.insertEmployeeInfo(employee);
		
		List<FileDTO> fileList = FileUtils.uploadFile(employee, session);
		
		if(!fileList.isEmpty()) {
			fileMapper.insertFiles(fileList); // 새이미지저장
		}
		
		return inputCount;
	}
	
	//직원아이디 사용해서 직원정보 선택
	public EmployeeInfoDTO getEmployeeInfo(EmployeeInfoDTO employee) {
		String empId = employee.getEmpId();
		return employee;
//		return employeeManagementMapper.selectEmployeeInfo(empId);
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
	public EmployeeInfoDTO getOneEmployeeInfoByEmpIdx(Integer empIdx) {
		return employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(empIdx);
	}
	// 회원정보 업데이트 
	@Transactional
	public int modifyEmployeeInfo(EmployeeInfoDTO employee) throws IllegalStateException, IOException {
		Integer empIdx = employee.getEmpIdx();
		EmployeeInfoDTO OgEmployee = employeeManagementMapper.selectOneEmployeeInfoByEmpIdx(empIdx);
		// 새로 받은 비밀번호가 존재한다면 암호화
		if(employee.getEmpPassword() != null && !employee.getEmpPassword().trim().isEmpty()) {
			String encodedPassword = passwordEncoder.encode(employee.getEmpPassword());
			employee.setEmpPassword(encodedPassword);
		}
		// 이메일 전화번호 비밀번호 저장
		int updateCount = employeeManagementMapper.updateEmployeeInfo(employee);
		
		// 입력받은 프로필 사진이 있을때
		if(employee.getFiles() != null && employee.getFiles().length > 0) {
			
			// 기존 저장된 프로필사진이존재 한다면 파일을 지우고
			if(session.getAttribute("sFIdx") != null) {
				//기존 파일 정보
				FileDTO file = fileMapper.getFileWithTargetTable("employee_info", empIdx);
				
				FileUtils.deleteFile(file, session);
				// 새로 등록하는 파일 업로드
				List<FileDTO> fileList = FileUtils.uploadFile(employee, session);
				// 파일DB 업로드
				if(!fileList.isEmpty()) {
					for(FileDTO files : fileList) {
						System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
						System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
						System.out.println(files);
						System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
						System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
					}
				}
			}
		} else {// 입력된 사진이 없을때
			
			// 기존 저장된 프로필사진이존재 한다면 파일을 삭제
			if(session.getAttribute("sFIdx") != null) {
				//기존 파일 정보
				FileDTO file = fileMapper.getFileWithTargetTable("employee_info", empIdx);
				FileUtils.deleteFile(file, session);
				fileMapper.deleteFile(file.getIdx());
				session.removeAttribute("sFId");
			}
		}
		
		return updateCount;
	}






	
	
}
