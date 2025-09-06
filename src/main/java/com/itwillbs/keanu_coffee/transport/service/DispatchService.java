package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.transport.dto.DispatchAssignmentDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegisterRequestDTO;
import com.itwillbs.keanu_coffee.transport.mapper.DispatchMapper;
import com.itwillbs.keanu_coffee.transport.mapper.VehicleMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DispatchService {
	private final DispatchMapper dispatchMapper;
	private final VehicleMapper vehicleMapper;
	
	// 페이징을 위한 배차 수
	@Transactional(readOnly = true)
	public int getDispatchCount(String filter, String searchKeyword) {
		return dispatchMapper.selectDispatchCount(filter, searchKeyword);
	}
	
	// 배차 리스트
	@Transactional(readOnly = true)
	public List<DispatchRegionGroupViewDTO> selectAllDispatch(int startRow, int listLimit, String filter,
			String searchKeyword) {
		return dispatchMapper.selectAllDispatch(startRow, listLimit, filter, searchKeyword);
	}

	// 배차 요청 리스트
	@Transactional(readOnly = true)
	public List<DispatchRegionGroupViewDTO> getDispatchList() {
		return dispatchMapper.selectDispatchList();
	}

	// 배차 등록
	@Transactional
	public void insertDispatch(DispatchRegisterRequestDTO request) {
		if (request.getDrivers().size() == 1) {
			request.setRequiresAdditional('N');
		} else {
			request.setRequiresAdditional('Y');
		}
		
		request.setStatus("예약");
		
		// 배차 테이블 데이터 등록
		dispatchMapper.insertDispatch(request);
		Integer dispatchIdx = request.getDispatchIdx();
		
		for (DispatchAssignmentDTO driver: request.getDrivers()) {
			DispatchAssignmentDTO assignment  = new DispatchAssignmentDTO();
			assignment.setEmpIdx(driver.getEmpIdx());
			assignment.setVehicleIdx(driver.getVehicleIdx());
			assignment.setStatus("예약");
			assignment.setDispatchIdx(dispatchIdx);
			
			// 배차 배정 테이블 데이터 등록
			dispatchMapper.insertDispatchAssignment(assignment);
			
			// 차량 상태 업데이트
			vehicleMapper.updateVehicleStatus(assignment);
		}
		
		
		List<Integer> orderIdList = request.getOrderList();
		
		for (Integer outboundOrderIdx : orderIdList) {
			// 배차 매핑 테이블 데이터 등록
			dispatchMapper.insertDispatchOrderMap(outboundOrderIdx, dispatchIdx);
			
			// 출고 주문 테이블 상태 변경
			dispatchMapper.updateOutboundOrderStatus(outboundOrderIdx, "배차완료");
		}
	}

	// 배차 취소
	@Transactional
	public void updateDispatchStatus(DispatchRegisterRequestDTO request) {
		List<Integer> orderIdList = request.getOrderList();
		request.setStatus("취소");
		
		for (Integer outboundOrderIdx : orderIdList) {
			// 출고주문idx로 배차 idx 조회
			Integer dispatchIdx = dispatchMapper.selectByorderIdList(outboundOrderIdx);
			
			dispatchMapper.updateDispatchStatus(dispatchIdx, request.getStatus());
		}
		
	}

	// 배차 상세 정보
	public DispatchRegionGroupViewDTO selectDispatchInfo(Integer dispatchIdx, Integer vehicleIdx) {
		// 배차 상태 확인
		String status = dispatchMapper.selectDispatchStatus(dispatchIdx);
//		
//		if (status.equals("예약") || status.equals("취소")) {
//			return dispatchMapper.selectDispatchSummary(dispatchIdx);
//		} else {
//			return dispatchMapper.selectDispatchDetail(dispatchIdx);
//		}
		
		return dispatchMapper.selectDispatchSummary(dispatchIdx, vehicleIdx);
	}

}
