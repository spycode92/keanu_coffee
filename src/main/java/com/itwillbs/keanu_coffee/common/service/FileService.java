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
	
	@Autowired
	private HttpSession session;
	private final FileMapper fileMapper;
	
	// -----------------------------------------

	public FileDTO getFile(int fileIdx) {
		
		return fileMapper.getFileWithFileIdx(fileIdx);
	}

	public FileDTO getFile(String targetTable, int targetTableIdx ) {
		
		return fileMapper.getFileWithTargetTable(targetTable, targetTableIdx);
	}
	
	
	
	
}
