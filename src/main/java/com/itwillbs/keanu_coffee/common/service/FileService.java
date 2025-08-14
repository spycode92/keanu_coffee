package com.itwillbs.keanu_coffee.common.service;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.mapper.FileMapper;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FileService {
	
	private final FileMapper fileMapper;

	@Autowired
	private HttpSession session;
	
	public void removeFile(FileDTO fileDTO) {
		// TODO Auto-generated method stub
		fileDTO = fileMapper.selectFile(fileDTO);
		FileUtils.deleteFile(fileDTO, session);
		
		fileMapper.deleteFile(fileDTO);
	}
	
	// 단일 파일 정보 조회
	public FileDTO getFile(String idx, String type) {
		
		if (type.equals("thumbnail")) {
			return fileMapper.selectThumbnailFile(idx);
		} else {
			return fileMapper.selectContentFile(idx);
		}
	}
	
	// 썸네일 파일 삭제
	public void removeThumbnailFile(FileDTO thumbnailFile) {
		FileDTO thumbnail = fileMapper.selectThumbnailFile(thumbnailFile.getIdx());
		FileUtils.deleteFile(thumbnail, session);
		fileMapper.deleteThumbnailFile(thumbnail);
	}
	
	// 파일정보조회(fileId)
	public FileDTO getFile(int fileId) {
		
		return fileMapper.selectFileInfo(fileId);
	}
	
	// 썸네일정보조회(fileId)
	public FileDTO getThumbnail(int fileId) {
		return fileMapper.selectThumbnailInfo(fileId);
	}
	
	
}
