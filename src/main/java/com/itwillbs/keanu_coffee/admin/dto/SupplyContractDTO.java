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
public class SupplyContractDTO {

	private Integer supplyContractIdx;
	private Integer supplierIdx;
    private Integer productIdx;
    private Integer contractPrice;
    private Date contractStart;
    private Date contractEnd;
    private Integer minOrderQuantity;
    private Integer maxOrderQuantity;
    private String status; // ENUM('계약중', '대기', '계약만료', '취소')

	// 공통
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}
