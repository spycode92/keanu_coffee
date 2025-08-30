package com.itwillbs.keanu_coffee.admin.dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.utils.FileUtils.FileUploadHelpper;

import lombok.Data;

@Data
public class SupplierDTO {
	// 공급업체정보
	private Integer supplierIdx;
	private String supplierName;
	private String supplierManager;
	private String supplierManagerPhone;
	private String supplierZipcode;
	private String supplierAddress1;
	private String supplierAddress2;
	private String status; //ENUM 활성 비활성 삭제
	
	
}
