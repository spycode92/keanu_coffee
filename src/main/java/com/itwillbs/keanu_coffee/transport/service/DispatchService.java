package com.itwillbs.keanu_coffee.transport.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.keanu_coffee.transport.dto.DeliveryConfirmationDTO;
import com.itwillbs.keanu_coffee.transport.dto.DeliveryConfirmationItemDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchAssignmentDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchCompleteRequest;
import com.itwillbs.keanu_coffee.transport.dto.DispatchDetailDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegionGroupViewDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchRegisterRequestDTO;
import com.itwillbs.keanu_coffee.transport.dto.DispatchStopDTO;
import com.itwillbs.keanu_coffee.transport.dto.RouteDTO;
import com.itwillbs.keanu_coffee.transport.mapper.DispatchMapper;
import com.itwillbs.keanu_coffee.transport.mapper.RouteMapper;
import com.itwillbs.keanu_coffee.transport.mapper.VehicleMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DispatchService {
	private final DispatchMapper dispatchMapper;
	private final VehicleMapper vehicleMapper;
	private final RouteMapper routeMapper;
	
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
	
	// 배차 상태 조회
	public String getDispatchStatus(Integer dispatchIdx) {
		return dispatchMapper.selectDispatchStatus(dispatchIdx);
	}

	// 배차 상세 정보
	public DispatchRegionGroupViewDTO selectDispatchInfo(Integer dispatchIdx, Integer vehicleIdx) {
		return dispatchMapper.selectDispatchSummary(dispatchIdx, vehicleIdx);
	}
	
	// 적재 완료 후 상세조회
	public DispatchDetailDTO selectDispatchDetail(Integer dispatchIdx, Integer vehicleIdx) {
		return dispatchMapper.selectDispatchDetail(dispatchIdx, vehicleIdx);
	}

	// 배차 정보 조회 (차량idx로 조회)
	public List<DispatchRegionGroupViewDTO> selectDispatchByVehicleIdx(Integer vehicleIdx) {
		return dispatchMapper.selectDispatchByVehicleIdx(vehicleIdx);
	}

	// 마이페이지 배차 상세 정보 조회
	public DispatchDetailDTO selectMyDispatchInfo(Integer dispatchIdx, Integer vehicleIdx) {
		return dispatchMapper.selectMyDispatchInfo(dispatchIdx, vehicleIdx);
	}

	// 마이페이지 적재 등록
	@Transactional
	public void insertDispatchLoad(DispatchCompleteRequest request) {
		// 배차 테이블 상태 변경
		dispatchMapper.updateDispatchStatus(request.getDispatchIdx(), "적재완료");
		
		Integer assigmentIdx = dispatchMapper.selectAssigmentIdx(request.getDispatchIdx(), request.getVehicleIdx());
		
		// 선택한 지점별 처리
		for (DispatchCompleteRequest.StopComplete stopReq: request.getStops()) {
			dispatchMapper.updateOutboundOrderStatus(stopReq.getOutboundOrderIdx(), "적재완료");
			
			// 경로 조회
			RouteDTO route = routeMapper.selectFranchise(stopReq.getFranchiseIdx());
			
			if (route == null) {
				throw new IllegalStateException("해당 지점에 대한 경로 정보가 없습니다.");
			}
			
			DispatchStopDTO dispatchStop = new DispatchStopDTO();
			dispatchStop.setDispatchIdx(request.getDispatchIdx());
			dispatchStop.setDispatchAssignmentIdx(assigmentIdx);
			dispatchStop.setFranchiseIdx(stopReq.getFranchiseIdx());
			dispatchStop.setDeliverySequence(route.getDeliverySequence());
			dispatchStop.setStatus("대기");
			dispatchStop.setUrgent('N');
			
			// 경유지 데이터 등록
			dispatchMapper.insertDispatchStop(dispatchStop);
			
			DeliveryConfirmationDTO confirmation = new DeliveryConfirmationDTO();
			confirmation.setDispatchAssignmentIdx(assigmentIdx);
			confirmation.setDispatchStopIdx(dispatchStop.getDispatchStopIdx());
			confirmation.setOutboundOrderIdx(stopReq.getOutboundOrderIdx());
			
			// 수주확인서 데이터 등록
			dispatchMapper.insertDeliveryConfirmation(confirmation);
			
			for (DispatchCompleteRequest.ItemComplete itemReq: stopReq.getItems()) {
				DeliveryConfirmationItemDTO confirmItem = new DeliveryConfirmationItemDTO();
				confirmItem.setConfirmationIdx(confirmation.getDeliveryConfirmationIdx());
				confirmItem.setProductIdx(itemReq.getProductIdx());
				confirmItem.setItemName(itemReq.getItemName());
				confirmItem.setOrderedQty(itemReq.getOrderedQty());
				
				// 수주확인서 품목 데이터 등록
				dispatchMapper.insertDeliveryConfirmationItem(confirmItem);
			}
		}
		
	}

}
