package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;


import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.admin.dto.FranchiseDTO;
import com.itwillbs.keanu_coffee.admin.mapper.FranchiseMapper;
import com.itwillbs.keanu_coffee.common.aop.annotation.SystemLog;
import com.itwillbs.keanu_coffee.common.aop.targetEnum.SystemLogTarget;
import com.itwillbs.keanu_coffee.transport.dto.AdministrativeRegionDTO;
import com.itwillbs.keanu_coffee.transport.dto.MappingDTO;
import com.itwillbs.keanu_coffee.transport.dto.RouteDTO;
import com.itwillbs.keanu_coffee.transport.service.RouteService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FranchiseService {
	
	private final FranchiseMapper franchiseMapper;
	private final RouteService routeService;
	
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
	@SystemLog(target = SystemLogTarget.FRANCHISE)
	public void addFranchiseInfo(FranchiseDTO franchise) {
		
		franchiseMapper.insertFranchiseInfo(franchise);
		
		AdministrativeRegionDTO administrativeRegionDTO = franchiseMapper.selectAdministartiveRegionInfo(franchise);
		
		// 새로등록한 지점의 행정구역이 행정구역테이블에 없을때
		if (administrativeRegionDTO == null) {
			//행정정보등록(중복된값이없을경우에만)
			franchiseMapper.insertAdministrativeRegionInfo(franchise);
		}else { //이미 등록된 행정구역이 있다면
			//행정구역과 맵핑된 구역 정보 가져오기
			MappingDTO mapping = franchiseMapper.selectMappingInfoWithAdministrativeRegionIdx(administrativeRegionDTO);
			//구역정보 franchise에저장
			franchise.setRegionIdx(mapping.getRegionIdx());
			// 프렌차이즈 테이블에 구역정보 입력
			franchiseMapper.updateRegionIdx(franchise.getFranchiseIdx(), franchise.getRegionIdx());
			//경로테이블에 경로 정보 저장
			RouteDTO route = new RouteDTO();
			route.setRegionIdx(franchise.getRegionIdx());
			route.setFranchiseIdx(franchise.getFranchiseIdx());
			//루트서비스 애드루트 실행
			routeService.addRoute(route);
		}
	}
	
	//지점상세정보조회
	@Transactional(readOnly = true)
	public FranchiseDTO getFranchiseDetail(Integer franchiseIdx) {
		
		return franchiseMapper.selectFranchiseDetail(franchiseIdx);
	}
	
	//지점정보수정
	@Transactional
	@SystemLog(target = SystemLogTarget.FRANCHISE)
	public int modifyFranchiseInfo(FranchiseDTO franchise) {
		
		FranchiseDTO ogData = franchiseMapper.selectFranchiseDetail(franchise.getFranchiseIdx());
		//지점 정보 수정
		int updateCount = franchiseMapper.updateFranchiseInfo(franchise);

		//bcode가 변경됐다면
		if(!ogData.getAdministrativeRegion().getBcode().equals(franchise.getAdministrativeRegion().getBcode())) {
			//변경전 BCODE를 쓰는 다른 지점이있나 확인
			int bcodeCount = franchiseMapper.selectCountBcode(ogData.getAdministrativeRegion().getBcode());
			
			if(bcodeCount == 0) { //사용되는 Bcode가없을경우
				//행정정보삭제(사용되는지점이없을경우)
				franchiseMapper.deleteAdministratveRegionInfo(ogData.getAdministrativeRegion().getBcode());
				//행정정보 구역 맵핑 테이블 삭제
				franchiseMapper.deleteMapping(ogData.getAdministrativeRegion().getBcode());
			}
			//해당 프렌차이즈지점의 경로 삭제 
			franchiseMapper.deleteRoute(franchise.getFranchiseIdx());
			//새로등록한 BCODE가 신규BCODE인지 판별
			int newBcodeCount = franchiseMapper.selectCountBcode(franchise.getAdministrativeRegion().getBcode());
			//이미 등록된 BCODE일경우
			if(newBcodeCount > 1) {
				AdministrativeRegionDTO administrativeRegionDTO = franchiseMapper.selectAdministartiveRegionInfo(franchise);
				//행정구역과 맵핑된 구역 정보 가져오기
				MappingDTO mapping = franchiseMapper.selectMappingInfoWithAdministrativeRegionIdx(administrativeRegionDTO);
				//구역정보 franchise에저장
				franchise.setRegionIdx(mapping.getRegionIdx());
				// 프렌차이즈 테이블에 구역정보 입력
				franchiseMapper.updateRegionIdx(franchise.getFranchiseIdx(), franchise.getRegionIdx());
				//경로테이블에 경로 정보 저장
				RouteDTO route = new RouteDTO();
				route.setRegionIdx(franchise.getRegionIdx());
				route.setFranchiseIdx(franchise.getFranchiseIdx());
				//루트서비스 애드루트 실행
				routeService.addRoute(route);
			} else {
				//새행정정보삽입(중복되는정보가없을경우)
				franchiseMapper.insertAdministrativeRegionInfo(franchise);
			}
		}
		
		return updateCount;
	}

	// 등록된 구역이 있는지 확인
	public boolean countFranchiseByRegion(Integer regionIdx) {
		
		return franchiseMapper.countFranchiseByRegion(regionIdx) > 0;
	}

	// bcode로 프랜차이점 찾기
	public List<FranchiseDTO> findByBcode(String bcode) {
		
		return franchiseMapper.selectBecode(bcode);
	}

	// 구역 정보 추가
	public void updateRegionIdx(Integer franchiseIdx, Integer regionIdx) {
		
		franchiseMapper.updateRegionIdx(franchiseIdx, regionIdx);
	}







	
	
}
