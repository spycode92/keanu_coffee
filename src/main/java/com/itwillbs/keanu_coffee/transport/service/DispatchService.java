package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.mapper.DispatchMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DispatchService {
	private final DispatchMapper dispatchMapper;

	// 배차 요청 리스트
	public List<DispatchRegionGroupViewDTO> getDispatchList() {
		return dispatchMapper.selectDispatchList();
	}

}
