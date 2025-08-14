package com.itwillbs.keanu_coffee.common.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.keanu_coffee.common.dto.FileDTO;
@Mapper
public interface FileMapper {
	
	FileDTO selectFile(FileDTO fileDTO);

	void deleteFile(FileDTO fileDTO);

	void insertFiles(List<FileDTO> fileList);

	List<FileDTO> selectAllFile(String idx);

	void deleteAllFile(String idx);

	// 썸네일 저장
	void insertThumbnail(FileDTO file);

	// 파일 한개 저장
	void insertOneFile(FileDTO file);

	// 썸네일 조회
	FileDTO selectThumbnailFile(String idx);

	// 컨텐츠 파일
	FileDTO selectContentFile(String idx);

	// 썸네일 파일 삭제
	void deleteThumbnailFile(FileDTO thumbnailFile);
	
	// 파일 정보 조회
	FileDTO selectFileInfo(int fileId);

	// 썸네일 정보 조회
	FileDTO selectThumbnailInfo(int fileId);
	


}
