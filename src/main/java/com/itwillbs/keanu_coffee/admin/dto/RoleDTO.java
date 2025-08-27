package com.itwillbs.keanu_coffee.admin.dto;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.common.dto.FileDTO;
import com.itwillbs.keanu_coffee.common.utils.FileUtils.FileUploadHelpper;

import lombok.Data;

@Data
public class RoleDTO {
	
	private Integer roleIdx;
	private String roleName;
	private Integer departmentIdx;
    
    private List<CommonCodeDTO> commonCodeList;
    
}
