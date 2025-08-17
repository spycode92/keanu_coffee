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
public class SupplierProductContractDTO implements FileUploadHelpper {
	//각테이블 고유번호
	private int idx;

	// 공급업체정보
	private Integer supplierIdx;
	private String supplierName;
	private String supplierManager;
	private String supplierManagerPhone;
	private String supplierZipcode;
	private String supplierAddress1;
	private String supplierAddress2;
	
	private Integer hasContract; //공급업체가 계약이있는지 없는지 확인
	
	
	//카테고리
	private Integer categoryIdx;
    private String categoryName;
    private Integer parentCategoryIdx;
    private String parentCategoryName;

	//상품정보
	private Integer productIdx;
	private String productName;
	private BigDecimal productWeight;
    private BigDecimal productWidth;
    private BigDecimal productLength;
    private BigDecimal productHeight;
    private BigDecimal productVolume;
    private String productFrom;
    
    //공급계약정보
    private Integer supplyContractIdx;
    private Integer contractPrice;
    private Date contractStart;
    private Date contractEnd;
    private Integer minOrderQuantitiy;
    private Integer maxOrderQuantity;
    private String status;

	// 공통
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;
	
	
	
	
	
	
	
	
	
	
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
		return idx;
	}
}
