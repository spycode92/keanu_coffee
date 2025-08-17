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
	private Integer idx;
	private String empNo;          // 사번 (PK)
	private String empName;        // 이름
	private String empGender;      // 성별
	private String deptName;       // 부서명
	private Integer departmentIdx; //부서고유번호
	private String teamName;     //팀명
	private Integer teamIdx; //팀고유번호
	private String roleName;    // 직급
	private Integer roleIdx; //직급고유번호
	private String empPhone;          // 전화번호
	private String empEmail;          // 이메일
	private String empId;          // 로그인 ID
    private String empPassword;    // 비밀번호
    private Date hireDate;         // 입사일
    private String empStatus;         // 재직 상태 ('재직','퇴사','휴직')
    private Timestamp createdAt;   // 생성일
    private Timestamp updatedAt;   // 수정일
    
    //프로필사진 등록 확인 파라미터
    private String profileImageAction;
    private String deleteProfileImgFlag;
    
	// 파일업로드
	private MultipartFile[] files;
	private List<FileDTO> fileList;
    
    @Override
	public MultipartFile[] getFiles(){
		return files;
	}
    @Override
	public String getTargetTable(){
		return "employee_info";
	}
	@Override
	public Integer getTargetTableIdx() {
		return idx;
	}
}
