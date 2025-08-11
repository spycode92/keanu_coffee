package com.itwillbs.keanu_coffee.admin.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class EmployeeDTO {
    // 직원 고유번호 (PK)
    private String empId;
    
    // 이름
    private String empName;
    
    // 이메일 (로그인 ID 용)
    private String empEmail;
    
    // 연락처
    private String empPhone;
    
    // 직책
    private String empPosition;
    
    // 부서명
    private String empTeam;
    
    // 재직 상태 (ACTIVE, INACTIVE, LEAVE 등)
    private String empStatus;
    
    // 입사일
    private LocalDate empHiredate;
    
    // 비밀번호 (암호화 저장)
    private String empPassword;
    
    // 등록일시
    private LocalDateTime regDate;
}
