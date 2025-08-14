package com.itwillbs.keanu_coffee.common.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.service.FileService;
import com.itwillbs.keanu_coffee.common.utils.FileUtils;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/file")
@AllArgsConstructor
public class FileController {
	private final FileService fileService;
	
	@GetMapping("{fileId}")
	public ResponseEntity<Resource> downloadFile(@PathVariable("fileId")int fileId,
			@RequestParam("type") int type, HttpSession session) {
//		System.out.println("fileId : " + fileId);
		
		// BoardService - getBoardFile() 메서드 호출하여 파일 정보 조회
		// => 파라미터 : 파일 아이디  리턴타입 : BoardFileDTO(boardFileDTO)
		FileDTO fileDTO = fileService.getFile(fileId);
		
		// 썸네일 이미지의 경우 param을 2로 받아서 파일 조회
		if (type == 2) {
			fileDTO = fileService.getThumbnail(fileId);
		}
		// ---------------------------------------------------------------------------
		// FileUtils - getFile() 메서드 호출하여 실제 파일 가져오기
		// => 파라미터 : BoardFileDTO   리턴타입 : 
		Map<String, Object> map = FileUtils.getFileResource(fileDTO, type, session);
		
		Resource resource = (Resource)map.get("resource");
		ContentDisposition contentDisposition = (ContentDisposition)map.get("contentDisposition");
		System.out.println("resource : " + resource.toString());
		
		return ResponseEntity.ok()
		.contentType(MediaType.APPLICATION_OCTET_STREAM)
		.header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition.toString())
		.body(resource);
		
	}
}
