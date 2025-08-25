package com.itwillbs.keanu_coffee.common.controller;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.core.io.ByteArrayResource;
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
import net.coobird.thumbnailator.Thumbnails;

@Controller
@RequestMapping("/file")
@AllArgsConstructor
public class FileController {
	private final FileService fileService;
	
	@GetMapping("{fileIdx}")
	public ResponseEntity<Resource> downloadFile(@PathVariable("fileIdx")int fileIdx,
			HttpSession session) {
//		System.out.println("fileId : " + fileId);
		
		// BoardService - getBoardFile() 메서드 호출하여 파일 정보 조회
		// => 파라미터 : 파일 아이디  리턴타입 : BoardFileDTO(boardFileDTO)
		FileDTO fileDTO = fileService.getFile(fileIdx);
		
		// ---------------------------------------------------------------------------
		// FileUtils - getFile() 메서드 호출하여 실제 파일 가져오기
		// => 파라미터 : BoardFileDTO   리턴타입 : 
		Map<String, Object> map = FileUtils.getFileResource(fileDTO, session);
		
		Resource resource = (Resource)map.get("resource");
		ContentDisposition contentDisposition = (ContentDisposition)map.get("contentDisposition");
		
		return ResponseEntity.ok()
		.contentType(MediaType.APPLICATION_OCTET_STREAM)
		.header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition.toString())
		.body(resource);
		
	}
	
	@GetMapping("/thumbnail/{fileIdx}")
	public ResponseEntity<ByteArrayResource> getThumbnail(
			@PathVariable int fileIdx,
	        @RequestParam(defaultValue = "200") int width,
	        @RequestParam(defaultValue = "200") int height,
	        HttpSession session) throws Exception {
		 // 1. 파일 정보(DB) 조회
	    FileDTO fileDTO = fileService.getFile(fileIdx);
	    
	    // 2. 실제 이미지 파일 경로 생성
	    String filePath = FileUtils.getFilePath(fileDTO, session);
	    
	    // null일때 대비
        if (filePath == null) {
            return ResponseEntity.notFound().build();
        }
	    
	    // 3. 썸네일 생성(메모리에)
	    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
	    Thumbnails.of(new File(filePath))
	            .size(width, height)        // 원하는 썸네일 크기(가로x세로)
	            .outputFormat("jpg")        // 확장자(필요에 따라 png 등)
	            .toOutputStream(outputStream);
	    byte[] thumbBytes = outputStream.toByteArray();

	    ByteArrayResource resource = new ByteArrayResource(thumbBytes);

	    // 4. ResponseEntity로 반환
	    return ResponseEntity.ok()
	            .contentLength(thumbBytes.length)
	            .contentType(MediaType.IMAGE_JPEG)
	            .body(resource);
	}
	
	
	
	
	
	
}
