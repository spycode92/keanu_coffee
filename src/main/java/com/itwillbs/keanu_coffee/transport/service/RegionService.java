package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.service.FranchiseService;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.transport.dto.AdministrativeRegionDTO;
import com.itwillbs.keanu_coffee.transport.mapper.RegionMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@RequiredArgsConstructor
@Log4j2
public class RegionService {
	private final RegionMapper regionMapper;
	private final FranchiseService franchiseService;

	// 구역 등록
	@Transactional
	public void addRegion(String regionName) {
		boolean isDuplicate = isRegionNameDuplicate(regionName);
		if (isDuplicate) {
			throw new DuplicateKeyException("이미 존재하는 구역명입니다.");
		}
		regionMapper.insertRegion(regionName);
	}

	// 구역 리스트
	public List<CommonCodeDTO> getRegionList() {
		return regionMapper.selectRegionList();
	}

	// 구역 이름 수정
	@Transactional
	public void modifyRegion(Integer commonCodeIdx, String commonCodeName) {
		boolean isDuplicate = isRegionNameDuplicate(commonCodeName);
		if (isDuplicate) {
			throw new DuplicateKeyException("이미 존재하는 구역명입니다.");
		}
		
		regionMapper.updateRegion(commonCodeIdx, commonCodeName);
	}
	
	// 구역 삭제
	@Transactional
	public void removeRegion(Integer commonCodeIdx) {
		 boolean isExist = isUsing(commonCodeIdx);
		 
		 if (isExist) {
			 throw new IllegalStateException("해당 구역에 등록된 지점이 있어 삭제할 수 없습니다.");
		 }
		regionMapper.deleteRegion(commonCodeIdx);
	}
	
	// 행정구역 리스트
	public List<AdministrativeRegionDTO> getAdministrativeRegionList() {
		// TODO Auto-generated method stub
		return null;
	}
	
	// 구역 이름 중복 검사
		private boolean isRegionNameDuplicate(String regionName) {
			return regionMapper.countRegionName(regionName) > 0;
		}
		
	// 사용 중인 구역인지 확인
		private boolean isUsing(Integer regionIdx) {
			return franchiseService.countFranchiseByRegion(regionIdx);
		}
}
