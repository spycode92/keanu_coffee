package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.transport.mapper.RegionMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RegionService {
	private final RegionMapper regionMapper;

	// 구역 등록
	public void addRegion(String regionName) {
		regionMapper.insertRegion(regionName);
	}

	// 구역 리스트
	public List<CommonCodeDTO> getRegionList() {
		return regionMapper.selectRegionList();
	}

}
