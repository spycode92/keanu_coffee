package com.itwillbs.keanu_coffee.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.keanu_coffee.admin.dto.EmployeeInfoDTO;
import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;
import com.itwillbs.keanu_coffee.transport.dto.AdministrativeRegionDTO;
import com.itwillbs.keanu_coffee.transport.dto.MappingDTO;

public interface FranchiseMapper {
	//직원목록 선택
	List<FranchiseDTO> selectFranchiseList(
			@Param("startRow") int startRow, @Param("listLimit") int listLimit, 
			@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword,
			@Param("orderKey")String orderKey, @Param("orderMethod")String orderMethod);
	// 직원목록 수
	int countFranchise(@Param("searchType")String searchType, @Param("searchKeyword")String searchKeyword);
	//지점 정보입력
	void insertFranchiseInfo(FranchiseDTO franchise);
	//행정정보입력
	void insertAdministrativeRegionInfo(FranchiseDTO franchise);
	//지점상세정보조회
	FranchiseDTO selectFranchiseDetail(Integer franchiseIdx);
	//행정정보 삭제
	void deleteAdministratveRegionInfo(String bcode);
	//행정정보 수정
	int updateFranchiseInfo(FranchiseDTO franchise);
	
	// 등록된 구역이 있는지 확인
	int countFranchiseByRegion(Integer regionIdx);
	
	// becode로 지점 찾기
	List<FranchiseDTO> selectBecode(String bcode);
	
	// 구역 정보 추가
	void updateRegionIdx(@Param("franchiseIdx") Integer franchiseIdx, @Param("regionIdx") Integer regionIdx);
	
	//행정구역 정보 조회
	AdministrativeRegionDTO selectAdministartiveRegionInfo(FranchiseDTO franchise);
	
	//행정구역과 맵핑된 구역정보가져오기
	MappingDTO selectMappingInfoWithAdministrativeRegionIdx(AdministrativeRegionDTO administrativeRegionDTO);
	
	//Bcode사용중인프렌차이즈지점수카운트
	int selectCountBcode(String bcode);
	//행정구역 구역 맵핑테이블 삭제
	void deleteMapping(String bcode);
	//경로테이블삭제
	void deleteRoute(Integer franchiseIdx);





}
