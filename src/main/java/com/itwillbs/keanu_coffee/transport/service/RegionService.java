package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.transport.mapper.RegionMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RegionService {
	private final RegionMapper regionMapper;

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
	public void removeRegion(Integer commonCodeIdx) {
		regionMapper.deleteRegion(commonCodeIdx);
		
	}
	
	// 구역 이름 중복 검사
	private boolean isRegionNameDuplicate(String regionName) {
		return regionMapper.countRegionName(regionName) > 0;
	}

	// 사용 중인 구역인지 확인
//	private boolean isUsing(Integer commonCodeIdx) {
//		return regionMapper.countFranchiseByRegion(commonCodeIdx);
//	}
}
