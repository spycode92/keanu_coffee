package com.itwillbs.keanu_coffee.admin.dto;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.utils.FileUtils.FileUploadHelpper;

import lombok.Data;

@Data
public class EmployeeInfoDTO implements FileUploadHelpper{
	private String empNo;          // 사번 (PK)
    private String empId;          // 로그인 ID
    private String empPassword;    // 비밀번호
    private String empName;        // 이름
    private String deptName;       // 부서명
    private String empPosition;    // 직급
    private Date hireDate;         // 입사일
    private String phone;          // 전화번호
    private String email;          // 이메일
    private String address;        // 주소
    private int salary;     // 급여
    private String status;         // 재직 상태 ('재직','퇴사','휴직')
    private Timestamp createdAt;   // 생성일
    private Timestamp updatedAt;   // 수정일
    
	// 파일업로드
	private MultipartFile[] files;
	private List<FileDTO> fileList;
    
    @Override
	public MultipartFile[] getFiles(){
		return files;
	}
	
	@Override
	public String getIdx() {
		return empNo;
	}
}
