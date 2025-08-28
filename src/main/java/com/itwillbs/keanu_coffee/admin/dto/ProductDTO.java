package com.itwillbs.keanu_coffee.admin.dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.utils.FileUtils.FileUploadHelpper;

import lombok.Data;

@Data
public class ProductDTO implements FileUploadHelpper {
	//카테고리
	private Integer categoryIdx;

	//상품정보
	private Integer productIdx;
	private String productName;
	private BigDecimal productWeight;
    private BigDecimal productWidth;
    private BigDecimal productLength;
    private BigDecimal productHeight;
    private BigDecimal productVolume;
    private String productFrom;
    private String status; // Enum 활성 비활성 삭제
    
	// 공통
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    private CommonCodeDTO commonCode;
    private FileDTO file;
    
    // 파일업로드
	@JsonIgnore
	private MultipartFile[] files;
	@JsonIgnore
	private List<FileDTO> fileList;
    
    @Override
	public MultipartFile[] getFiles(){
		return files;
	}
    
    @Override
	public String getTargetTable(){
		return "product";
	}
    
	@Override
	public Integer getTargetTableIdx() {
		return productIdx;
	}
}
