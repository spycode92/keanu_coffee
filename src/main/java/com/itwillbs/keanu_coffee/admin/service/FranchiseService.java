package com.itwillbs.keanu_coffee.admin.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;
import com.itwillbs.keanu_coffee.admin.mapper.FranchiseMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FranchiseService {
	
	private final FranchiseMapper franchiseMapper;
	
	@Autowired
	private HttpSession session;
	
	//지점목록선택
	@Transactional(readOnly = true)
	public List<FranchiseDTO> getFranchiseList(
			int startRow, int listLimit, String searchType, String searchKeyword, String orderKey, String orderMethod) {
		
		List<FranchiseDTO> List = franchiseMapper.selectFranchiseList(startRow, listLimit, searchType, searchKeyword, orderKey, orderMethod);
		return List;
	}
	
	// 지점 목록 갯수
	@Transactional(readOnly = true)
	public int getFranchiseCount(String searchType, String searchKeyword) {
		return franchiseMapper.countFranchise(searchType, searchKeyword );
	}
	
	// 지점정보입력
	@Transactional
	public void addFranchiseInfo(FranchiseDTO franchise) {
		franchiseMapper.insertFranchiseInfo(franchise);
		//행정정보등록(중복된값이없을경우에만)
		franchiseMapper.insertAdministrativeRegionInfo(franchise);
	}
	
	//지점상세정보조회
	@Transactional(readOnly = true)
	public FranchiseDTO getFranchiseDetail(Integer franchiseIdx) {
		return franchiseMapper.selectFranchiseDetail(franchiseIdx);
	}
	//지점정보수정
	@Transactional
	public int modifyFranchiseInfo(FranchiseDTO franchise) {
		FranchiseDTO ogData = franchiseMapper.selectFranchiseDetail(franchise.getFranchiseIdx());
		//지점 정보 수정
		int updateCount = franchiseMapper.updateFranchiseInfo(franchise);

		//bcode가 변경됐다면
		if(!ogData.getAdministrativeRegion().getBcode().equals(franchise.getAdministrativeRegion().getBcode())) {
			//행정정보삭제(사용되는지점이없을경우)
			franchiseMapper.deleteAdministratveRegionInfo(ogData.getAdministrativeRegion().getBcode());
			//새행정정보삽입(중복되는정보가없을경우)
			franchiseMapper.insertAdministrativeRegionInfo(franchise);
		}
		return updateCount;
	}







	
	
}
