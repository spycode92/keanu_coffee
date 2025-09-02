package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;
import com.itwillbs.keanu_coffee.admin.service.FranchiseService;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;
import com.itwillbs.keanu_coffee.transport.dto.AdministrativeRegionDTO;
import com.itwillbs.keanu_coffee.transport.dto.MappingDTO;
import com.itwillbs.keanu_coffee.transport.dto.RouteDTO;
import com.itwillbs.keanu_coffee.transport.mapper.RegionMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@RequiredArgsConstructor
@Log4j2
public class RegionService {
	private final RegionMapper regionMapper;
	private final FranchiseService franchiseService;
	private final RouteService routeService;

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
	
	// 행정구역 리스트
	public List<AdministrativeRegionDTO> getAdministrativeRegionList() {
		return regionMapper.selectAdministrativeRegionList();
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

	// 구역 매핑 등록
	@Transactional
	public void addMapping(MappingDTO mapping) {
		regionMapper.insertMapping(mapping);
		
		// bcode로 지점 정보 불러오기
		List<FranchiseDTO> franchises = franchiseService.findByBcode(mapping.getBcode());
		
		if (franchises != null) {
			for (FranchiseDTO franchise : franchises) {
				// 지점별 region_idx 추가
				franchiseService.updateRegionIdx(franchise.getFranchiseIdx(), mapping.getRegionIdx());
				
				RouteDTO route = new RouteDTO();
				route.setRegionIdx(mapping.getRegionIdx());
				route.setFranchiseIdx(franchise.getFranchiseIdx());
				
				routeService.addRoute(route);
			}
		}
	}
	
	// 구역별 행정 리스트
	public List<MappingDTO> getMappingRegionList() {
		return regionMapper.selectMappingRegionList();
	}
	
	// 매핑된 행정구역 삭제
	@Transactional
	public void removeMapping(Integer idx) {
		// 매핑 테이블 정보 조회
		MappingDTO mapping = regionMapper.findByIdx(idx);
		
		if (mapping == null) {
			return;
		}
		
		// 매핑 삭제
		regionMapper.deleteMapping(idx);
		
		// bcode로 지점 정보 불러오기
		List<FranchiseDTO> franchises = franchiseService.findByBcode(mapping.getBcode());
		
		if (franchises != null) {
			for (FranchiseDTO franchise : franchises) {
				// 지점의 region_idx의 값을 null로 변경
				franchiseService.updateRegionIdx(franchise.getFranchiseIdx(), null);
				
				// 배송 경로에서 관련 데이트 삭제
				routeService.deleteByRegionAndFranchise(mapping.getRegionIdx(), franchise.getFranchiseIdx());
			}
		}
		
	}
	
	// 매핑된 행정구역 그룹 삭제
	@Transactional
	public void removeAllMapping(List<Integer> idxList) {
		for (Integer idx: idxList) {
			MappingDTO mapping = regionMapper.findByIdx(idx);
			
			if (mapping == null) {
				continue;
			}
			
			List<FranchiseDTO> franchises = franchiseService.findByBcode(mapping.getBcode());
			
			if (franchises != null) {
				for (FranchiseDTO franchise : franchises) {
					franchiseService.updateRegionIdx(franchise.getFranchiseIdx(), null);
					
					routeService.deleteByRegionAndFranchise(mapping.getRegionIdx(), franchise.getFranchiseIdx());
				}
			}
		}
		
		regionMapper.deleteAllMapping(idxList);
		
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
