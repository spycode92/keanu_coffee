package com.itwillbs.keanu_coffee.common.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.common.dto.FileDTO;
@Mapper
public interface FileMapper {

	void insertFiles(List<FileDTO> fileList);

	FileDTO getFileWithFileIdx(int fileIdx);

	FileDTO getFileWithTargetTable(@Param("targetTable") String targetTable, @Param("targetTableIdx")int targetTableIdx);
	
	
	


}
