package com.itwillbs.keanu_coffee.common.dto;

import com.google.protobuf.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FileDTO {
	private int fileId; // 업로드 파일 ID(PK 값)
	private String idx; // 게시물 번호(FK 값)
	private String originalFileName; // 원본 파일명
	private String realFileName; // 실제 업로드 된 파일명
	private String subDir; // 서브디렉토리명
	private long fileSize;
	private String contentType;
	private Timestamp uploadDate;
}
