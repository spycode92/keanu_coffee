package com.itwillbs.keanu_coffee.common.utils;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.ContentDisposition.Builder;
import org.springframework.http.HttpStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.itwillbs.keanu_coffee.common.dto.FileDTO;

import lombok.extern.log4j.Log4j2;
@Log4j2
public class FileUtils {
//	private static String uploadPath = "/usr/local/tomcat/upload"; // 서버 업로드용
	private static String uploadPath = "/resources/upload"; // 로컬 작업용
	
//	private static Path absolutePath = Paths.get(uploadPath).toAbsolutePath().normalize();
	
	
	// 서브디렉토리 생성
	public static String createDirectories(String path) {

		LocalDate localDateNow = LocalDate.now();

		String datePattern = "yyyy/MM/dd";
		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);

		String subDir = localDateNow.format(dtf);

		path += "/" + subDir;
		
		try {
			Path resultPath = Files.createDirectories(Paths.get(path).toAbsolutePath().normalize());
		} catch (IOException e) {
			System.out.println("서브 디렉토리 생성 실패 - " + path);
			e.printStackTrace();
		}
		
		return subDir;
	}
	
	
	// 파일업로드 인터페이스
	public interface FileUploadHelpper{
		MultipartFile[] getFiles();
		String getTargetTable();
		Integer getTargetTableIdx();
	}
	
	// 파일 업로드
	public static List<FileDTO> uploadFile(FileUploadHelpper help, HttpSession session) throws IllegalStateException, IOException {
		String subDir = ""; // 서브디렉토리명을 저장할 변수 선언
		// --------------------------------------------------------
		// 프로젝트 상의 가상의 업로드 경로를 사용할 경우 추가 작업
//		String realPath = uploadPath; // 서버 업로드용
//		String realPath = session.getServletContext().getRealPath(uploadPath); // 로컬작업용[프로젝트]
		
		subDir = FileUtils.createDirectories(uploadPath);
		
		// 실제 파일 업로드 공간 : 업로드 경로와 서브 디렉토리 결합
		String destinationPath = uploadPath + "/" + subDir;
		List<FileDTO> fileList = new ArrayList<FileDTO>(); // 파일 정보들을 저장할 List 객체 생성
		for(MultipartFile mFile : help.getFiles()) {
			// 파일이 존재할 경우 실제 업로드 처리 및 BoardFileDTO 객체에 정보 저장
			if(!mFile.isEmpty()) {
				String originalFileName = mFile.getOriginalFilename();
	
				String uuid = UUID.randomUUID().toString();
				String realFileName = uuid + "_" + originalFileName;

				File destinationFile = new File(destinationPath, realFileName);
				
				mFile.transferTo(destinationFile);

				FileDTO fileDTO = new FileDTO();
				fileDTO.setTargetTable(help.getTargetTable());
				fileDTO.setTargetTableIdx(help.getTargetTableIdx());
				fileDTO.setOriginalFileName(originalFileName);
				fileDTO.setRealFileName(realFileName);
				fileDTO.setSubDir(subDir);
				fileDTO.setFileSize(mFile.getSize());
				fileDTO.setContentType(mFile.getContentType());
				
				fileList.add(fileDTO);
			}
		} 
		return fileList;
	}
	
	//파일 삭제
	public static void deleteFile(FileDTO fileDTO, HttpSession session) {
		
//		String realPath = uploadPath; // 서버 업로드용
		String realPath = session.getServletContext().getRealPath(uploadPath); // 로컬작업용
		
		Path path = Paths.get(realPath, fileDTO.getSubDir(), fileDTO.getRealFileName());

		try {
			Files.deleteIfExists(path);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	// 다중 파일 삭제
	public static void deleteFiles(List<FileDTO> fileList, HttpSession session) {
		
		for(FileDTO fileDTO : fileList) {
			FileUtils.deleteFile(fileDTO, session);
		}	
	}
	
	//파일 정보 호출
	public static Map<String, Object> getFileResource(FileDTO fileDTO, HttpSession session) {
		try {
//			String realPath = uploadPath; // 서버 업로드용
			String realPath = session.getServletContext().getRealPath(uploadPath); // 로컬작업용
			
			// 가져올 파일의 실제 위치 : 업로드 디렉토리의 파일 정보를 Path 객체로 가져오기
//			Path path = Paths.get(absolutePath.toString(), fileDTO.getSubDir()).resolve(fileDTO.getRealFileName()).normalize(); // 서버업로드용
			Path path = Paths.get(realPath, fileDTO.getSubDir()).resolve(fileDTO.getRealFileName()).normalize();
			
			// 해당 파일에 대한 Resource 객체 생성
			Resource resource = new UrlResource(path.toUri());
			
			//해당 경로 및 파일 존재 여부 판별 및 실제 접근 가능 여부도 확인
			if(!resource.exists() || !resource.isReadable()) {
				throw new ResponseStatusException(HttpStatus.NOT_FOUND, "파일을 찾을 수 없습니다!");
			}
			
			// 파일의 MIME 타입(= 컨텐츠 타입) 설정
			String contentType = Files.probeContentType(path); // 실제 파일로부터 파일 타입 알아내기
			System.out.println("contentType : " + contentType);
			
			if(contentType == null) {
				contentType = "application/octet-stream"; //일반적인 바이너리 타입으로 컨텐츠 타입 강제 고정
			}
			
			Builder builder = ContentDisposition.builder("attachment"); //다운로드해야 할때
			
			// 한글이나 공백 등이 포함된 파일명은 별도의 추가 작업 필요(파일명 인코딩 작업 필요)
			ContentDisposition contentDisposition = builder // 다운로드 형식 지정을 위한 ContentDisposition 객체 선언
				.filename(fileDTO.getOriginalFileName(), StandardCharsets.UTF_8) // 파일명 인코딩 방식 지정
				.build(); // 객체 생성
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("resource", resource);
			map.put("contentDisposition", contentDisposition);
			map.put("contentType", contentType);	
			
			
			return map;
		} catch (MalformedURLException e) {
			e.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "파일 다운로드 실패!");
		} catch (IOException e) {
			e.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "파일 정보 조회 실패!");
		}
	}
	
	//파일경로
	public static String getFilePath(FileDTO fileDTO, HttpSession session) {
	    try {
	        // null 체크 추가
	        if (fileDTO == null) {
	            System.err.println("FileDTO가 null입니다.");
	            return null;
	        }
	        
	        if (session == null || session.getServletContext() == null) {
	            System.err.println("Session 또는 ServletContext가 null입니다.");
	            return null;
	        }
	        
	        String realPath = session.getServletContext().getRealPath(uploadPath);
	        if (realPath == null) {
	            System.err.println("getRealPath()가 null을 반환했습니다.");
	            // 대체 경로 사용
	            realPath = System.getProperty("user.dir") + "/uploads";
	        }
	        
	        String subDir = fileDTO.getSubDir() != null ? fileDTO.getSubDir() : "";
	        String fileName = fileDTO.getRealFileName();
	        
	        if (fileName == null || fileName.trim().isEmpty()) {
	            System.err.println("파일명이 null 또는 빈 문자열입니다.");
	            return null;
	        }
	        
	        Path path = Paths.get(realPath, subDir, fileName);
	        return path.toString();
	        
	    } catch (Exception e) {
	        System.err.println("getFilePath 에러: " + e.getMessage());
	        e.printStackTrace();
	        return null;  // 예외 발생 시 null 반환
	    }
	}
	
	
}
