package com.itwillbs.keanu_coffee.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.admin.dto.TotalDashBoardDTO;
import com.itwillbs.keanu_coffee.admin.mapper.TotalDashBoardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TotalDashBoardService {
	private final TotalDashBoardMapper totalDashBoardMapper;
	
	//입고 데이터 조회
	public List<TotalDashBoardDTO> getInboundDashData(String needData, String startDate, String endDate) {
		
		if(needData.equals("daily")) {
			return totalDashBoardMapper.selectInboundDashDataByDay(startDate, endDate);
		}else if(needData.equals("weekly")) {
			return totalDashBoardMapper.selectInboundDashDataByWeek(startDate, endDate); 
		}else {
			return totalDashBoardMapper.selectInboundDashDataByMonth(startDate, endDate);
		}
		
		
	}
	
	// 출고 데이터 조회
	public List<TotalDashBoardDTO> getOutboundDashData(String needData, String startDate, String endDate) {
		if(needData.equals("daily")) {
			return totalDashBoardMapper.selectOutboundDashDataByDay(startDate, endDate);
		}else if(needData.equals("weekly")) {
			return totalDashBoardMapper.selectOutboundDashDataByWeek(startDate, endDate); 
		}else {
			return totalDashBoardMapper.selectOutboundDashDataByMonth(startDate, endDate);
		}
	}
	
	// 폐기데이터 조회
	public List<TotalDashBoardDTO> getDisposalDashData(String needData, String startDate, String endDate) {
		if(needData.equals("daily")) {
			return totalDashBoardMapper.selectDisposalDashDataByDay(startDate, endDate);
		}else if(needData.equals("weekly")) {
			return totalDashBoardMapper.selectDisposalDashDataByWeek(startDate, endDate); 
		}else {
			return totalDashBoardMapper.selectDisposalDashDataByMonth(startDate, endDate);
		}
	}
	//재고정보조회
	public List<TotalDashBoardDTO> getInventoryDashData() {
		
		return totalDashBoardMapper.selectInventory();
	}
	
	//창고용적율확인
	public List<TotalDashBoardDTO> getLocationDashData() {
		List<TotalDashBoardDTO> dash = totalDashBoardMapper.selectLocation(); 
		//상품물건 상자호수 대비 부피조정
		for(TotalDashBoardDTO D : dash) {
			long productVolume = D.getProductVolume();
			switch((int)productVolume) {
				case 3 : D.setProductVolume(34 * 25 * 21);
				break;
				case 4 : D.setProductVolume(41 * 31 * 28);
				break;
				case 5 : D.setProductVolume(48 * 37 * 34);
				break;
			}
		}
		
		return dash;
	}
	

}
