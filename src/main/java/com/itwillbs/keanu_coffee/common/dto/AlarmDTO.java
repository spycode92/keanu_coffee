package com.itwillbs.keanu_coffee.common.dto;


import java.sql.Timestamp;

import com.itwillbs.keanu_coffee.admin.dto.RoleDTO;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class AlarmDTO {
	private Integer alarmIdx; // 업로드 파일 ID(PK 값)
	private Integer empIdx;
	private String empAlarmMessage; // 원본 파일명
	private int empAlarmReadStatus; // 게시물 번호(FK 값)
	private String empAlarmLink; // 실제 업로드 된 파일명
	private Timestamp createdAt;
	private String roleName;
}
